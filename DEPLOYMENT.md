# Deployment Guide

## Prerequisites

- AWS Account
- Terraform
- Docker
- Node.js
- Python

## Clone Repository

git clone ...
cd project-hub

## Configure Environment Variables

Copy the backend environment  templates:
cp backend/.env.example backend/.env

update:
- backend/.env
- terraform.tfvars

with your own configuration.

## Deploy Infrastructure

- cd terraform 
- terraform apply

Terraform Format, Validation and Planning are automatically performed by the GitHub Actions workflow (terraform.yml) whenever terraform files are pushed


## Build Backend

Commit and push your backend changes:
- git add .
- git commit -m "Update Backend"
- git push

The deploy.yml GitHub Actions workflow automatically builds the Docker image, pushes it to Amazon ECR and deploys the latest version to Amazon ECS.

## Deploy Frontend

Commit and push your backend changes:
- git add .
- git commit -m "Update frontend"
- git push

The frontend.yml GitHub Actions workflow  automatically builds the React application.

## Verify Deployment

Verify that:
- The frontend is accesssible through the CloudFront URL.
- The ECS service is healthy.
- The backend API is responding.
- CloudWatch Dashboard displays application metrics.
