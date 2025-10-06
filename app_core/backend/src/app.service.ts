import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user/user.entity';

@Injectable()
export class AppService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  getHello(): string {
    return 'Hello World!';
  }

  async testDatabase(): Promise<string> {
    try {
      const userCount = await this.userRepository.count();
      return `Database connected successfully! User count: ${userCount}`;
    } catch (error) {
      return `Database connection failed: ${error instanceof Error ? error.message : String(error)}`;
    }
  }
}
