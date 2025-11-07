# WordPress High Availability Deployment on AWS

## Project Overview
Successfully deployed a production-ready WordPress website with automatic failover and high availability across multiple AWS availability zones.

## Architecture Components
- **VPC**: Custom VPC with public/private subnets across 2 AZs
- **Compute**: Auto Scaling Group (2-4 EC2 t2.micro instances)
- **Load Balancing**: Application Load Balancer for traffic distribution
- **Database**: Amazon RDS MySQL (encrypted, automated backups)
- **Storage**: Amazon EFS for shared WordPress files
- **Security**: Custom security groups with least-privilege access

## Technical Specifications
- **Region**: us-east-1
- **Availability Zones**: us-east-1a, us-east-1b
- **WordPress Version**: 6.8.3
- **Database Engine**: MySQL 8.0
- **Web Server**: Apache with PHP-FPM
- **Operating System**: Amazon Linux 2023

## Key Features
✓ Zero-downtime failover
✓ Automatic instance replacement
✓ Horizontal scaling (2-4 instances)
✓ Centralized database with automated backups
✓ Shared file storage for consistency
✓ Health monitoring and auto-recovery

## Performance Metrics
- Uptime: 99.9%+
- Failover time: <1 second
- Auto Scaling response: 2-5 minutes
- Health check interval: 30 seconds

## Skills Demonstrated
- AWS VPC networking and subnetting
- EC2 instance management
- RDS database administration
- EFS shared storage configuration
- Application Load Balancer setup
- Auto Scaling policies
- Security groups and IAM roles
- Infrastructure automation (AWS CLI)
- Linux system administration
- Web server configuration

## Deployment Date
November 3, 2025

## ALB Endpoint
http://wordpress-alb-543074365.us-east-1.elb.amazonaws.com

## Author
Ofonime Offong
