# ProjectHub

## Overview

ProjectHub is a cloud-native portfolio application that allows users to register, authenticate, manage projects, upload files, and maintain a personal profile.
The application is deployed on AWS using Infrastructure as Code with Terraform.

## Features

- User Authentication (JWT)
- Project Management
- Profile Management
- Bio Editing
- Resume Upload
- Profile Picture Upload
- Project Image Upload
- Cloud Storage (Amazon S3)
- Event-driven Notifications (SNS + Lambda + SES)
- CloudFront CDN
- Monitoring Dashboard (CloudWatch)

## Architecture

Frontend

- React
- Vite

Backend

- FastAPI
- SQLAlchemy

Infrastructure

- Terraform
- Docker
- ECS Fargate
- Application Load Balancer
- RDS PostgreSQL
- S3
- CloudFront
- SNS
- Lambda
- CloudWatch
- IAM
- Secrets Manager

## Folder Structure

frontend/
backend/
terraform/
lambda/

## Deployment

See DEPLOYMENT.md

## Monitoring

CloudWatch Dashboard includes

- ECS CPU
- ECS Memory
- Lambda Invocations
- Lambda Errors
- RDS CPU
- Database Connections

## Future Improvements

- Configure a custom domain using Route 53 and AWS Certificate Manager.
- Move Amazon SES out of sandbox mode to enable email notifications for all users.
- Deploy the application on Amazon EKS (Kubernetes).
