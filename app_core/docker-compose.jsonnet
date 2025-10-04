local postgres = {
  image: 'postgres:15-alpine',
  container_name: 'multitenant_postgres',
  restart: 'unless-stopped',
  environment: {
    POSTGRES_DB: 'multitenant_db',
    POSTGRES_USER: 'postgres',
    POSTGRES_PASSWORD: 'postgres123',
    PGDATA: '/var/lib/postgresql/data/pgdata',
  },
  ports: [
    '5432:5432',
  ],
  volumes: [
    'postgres_data:/var/lib/postgresql/data',
    './init-scripts:/docker-entrypoint-initdb.d',
  ],
  networks: [
    'multitenant_network',
  ],
  healthcheck: {
    test: ['CMD-SHELL', 'pg_isready -U postgres -d multitenant_db'],
    interval: '10s',
    timeout: '5s',
    retries: '5',
  },
};

local backend = {
  build: {
    context: '.',
    dockerfile: 'Dockerfile',
  },
  container_name: 'multitenant_backend',
  restart: 'unless-stopped',
  environment: {
    NODE_ENV: 'production',
    PORT: '3000',
    DATABASE_HOST: 'postgres',
    DATABASE_PORT: '5432',
    DATABASE_NAME: 'multitenant_db',
    DATABASE_USER: 'postgres',
    DATABASE_PASSWORD: 'postgres123',
    DATABASE_URL: 'postgresql://postgres:postgres123@postgres:5432/multitenant_db',
  },
  ports: [
    '3000:3000',
  ],
  depends_on: {
    postgres: {
      condition: 'service_healthy',
    },
  },
  networks: [
    'multitenant_network',
  ],
  healthcheck: {
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

local pgadmin = {
  image: 'dpage/pgadmin4:latest',
  container_name: 'multitenant_pgadmin',
  restart: 'unless-stopped',
  environment: {
    PGADMIN_DEFAULT_EMAIL: 'admin@multitenant.com',
    PGADMIN_DEFAULT_PASSWORD: 'admin123',
    PGADMIN_CONFIG_SERVER_MODE: 'False',
  },
  ports: [
    '5050:80',
  ],
  depends_on: [
    'postgres',
  ],
  networks: [
    'multitenant_network',
  ],
  volumes: [
    'pgadmin_data:/var/lib/pgadmin',
  ],
};

{
  services: {
    postgres: postgres,
    backend: backend,
    pgadmin: pgadmin,
  },
  volumes: {
    postgres_data: {
      driver: 'local',
    },
    pgadmin_data: {
      driver: 'local',
    },
  },
  networks: {
    multitenant_network: {
      driver: 'bridge',
    },
  },
}
