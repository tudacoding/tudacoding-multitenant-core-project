local env = if std.extVar('ENV') != '' then std.extVar('ENV') else 'development';

// Database configuration
local dbConfig = {
  name: 'multitenant_db',
  user: 'postgres',
  password: 'postgres123',
  port: '5432',
};

// Common service configuration
local commonConfig = {
  restart: 'unless-stopped',
  networks: ['multitenant_network'],
};

// Health check configurations
local healthChecks = {
  postgres: {
    test: ['CMD-SHELL', 'pg_isready -U %s -d %s' % [dbConfig.user, dbConfig.name]],
    interval: '10s',
    timeout: '5s',
    retries: '5',
  },
  backend: {
    test: [
      'CMD-SHELL',
      'node -e "require(\'http\').get(\'http://localhost:3000/health\', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"',
    ],
    interval: '30s',
    timeout: '10s',
    retries: '3',
    start_period: '40s',
  },
};

// Database URL helper
local dbUrl = 'postgresql://%s:%s@postgres:%s/%s' % [dbConfig.user, dbConfig.password, dbConfig.port, dbConfig.name];

// Backend environment variables
local backendEnv = {
  NODE_ENV: env,
  PORT: '3000',
  DATABASE_HOST: 'postgres',
  DATABASE_PORT: dbConfig.port,
  DATABASE_NAME: dbConfig.name,
  DATABASE_USER: dbConfig.user,
  DATABASE_PASSWORD: dbConfig.password,
  DATABASE_URL: dbUrl,
};

// PostgreSQL service
local postgres = commonConfig + {
  image: 'postgres:15-alpine',
  container_name: 'multitenant_postgres',
  environment: {
    POSTGRES_DB: dbConfig.name,
    POSTGRES_USER: dbConfig.user,
    POSTGRES_PASSWORD: dbConfig.password,
    PGDATA: '/var/lib/postgresql/data/pgdata',
  },
  ports: ['5432:5432'],
  volumes: [
    'postgres_data:/var/lib/postgresql/data',
    './init-scripts:/docker-entrypoint-initdb.d',
  ],
  healthcheck: healthChecks.postgres,
};

// Backend service configuration
local backendConfig = commonConfig + {
  container_name: 'multitenant_backend',
  environment: backendEnv,
  ports: ['3000:3000'],
  depends_on: {
    postgres: {
      condition: 'service_healthy',
    },
  },
  healthcheck: healthChecks.backend,
};

// Backend service with environment-specific build
local backend = if env == 'development' then
  backendConfig + {
    build: {
      context: '.',
      dockerfile: 'Dockerfile.dev',
    },
    volumes: [
      './backend:/app',
      '/app/node_modules',
    ],
  }
else
  backendConfig + {
    build: {
      context: '.',
      dockerfile: 'Dockerfile.prod',
    },
  };

// PgAdmin service
local pgadmin = commonConfig + {
  image: 'dpage/pgadmin4:latest',
  container_name: 'multitenant_pgadmin',
  environment: {
    PGADMIN_DEFAULT_EMAIL: 'admin@multitenant.com',
    PGADMIN_DEFAULT_PASSWORD: 'admin123',
    PGADMIN_CONFIG_SERVER_MODE: 'False',
  },
  ports: ['5050:80'],
  depends_on: ['postgres'],
  volumes: ['pgadmin_data:/var/lib/pgadmin'],
};

// Main configuration
{
  services: {
    postgres: postgres,
    backend: backend,
    pgadmin: pgadmin,
  },
  volumes: {
    postgres_data: { driver: 'local' },
    pgadmin_data: { driver: 'local' },
  },
  networks: {
    multitenant_network: { driver: 'bridge' },
  },
}
