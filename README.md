This is my final project for Data Engineering Zoomcamp.

- Name: Pham Nguyen Hung
- Signed-up email: hungpn032003@gmail.com

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Disclaimer](#disclaimer)
- [Problem statement](#problem-statement)
- [Architecture](#architecture)
- [How to run](#how-to-run)
  - [Step 1. Resource creation (`terraform` folder)](#step-1-resource-creation-terraform-folder)
  - [Step 2 - 5. Pipeline creation (`pipeline` folder)](#step-2---5-pipeline-creation-pipeline-folder)
    - [Change config file](#change-config-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Disclaimer

I started the course late and did not finish Week 5 and Week 6 before doing the project. I also went into a sprint at work so I decided to complete a minimal project first before revisit the materials when I have a respite. Being minimal, this project will pass each quantitative category while being very non-extra-ordinary.

# Problem statement

I used the Kaggle dataset [New York Times Best Sellers](https://www.kaggle.com/datasets/dhruvildave/new-york-times-best-sellers), which containers all weekly New York Times Best Sellers List for the decade fo 2010-2019. The general question was "What is the profile of the top 100 New York Times Best Sellers of the decade?" Top 100 was selected based on *number of weekly appearances on the list* (more is better) and *average weekly ranking* (smaller is better). From this, I created a dashboard with 2 tiles to describe

1. The number of titles in each category appeared on the list.
2. The number of weekly appearances for top authors.

# Architecture

![Project architecture (my own work)](./media/Architecture.png)

The project made use of technologies introduced in the first 4 weeks of the course: Terraform, Docker, Mage AI, Google Cloud Storage (GCS), BigQuery, dbt, and Looker Studio.

- The cloud resources were generated with Terraform.
- Downloading the data from Kaggle was a bit complicated with Mage AI. I decided to download the file and upload it to a GCS bucket as a surrogate 3rd parth server instead.
- Mage AI was used to create and orchestrate 2 ETL pipelines to ingest the data to the data lake and then the data warehouse.
- dbt was used to create the data transformation model from the base table in the data warehouse used to create the visualizations for the dashboard.
- Looker Studio was used to create dashboard from the data in BigQuery.

# How to run

The code for each part are included in the relevant folder of the repo. The specific changes will be presented sequentially below. Starting from `root`:

- `dbt`: contains file for my dbt model.
- `pipeline`: contains file for Mage pipelines.
- `terraform`: contains file for Terraform resource creation.
- `bestsellers.csv`: the original file from Kaggle.
  
## Step 1. Resource creation (`terraform` folder)

The requirements here are one or more GCS buckets and a BigQuery schema, which is quite similar to what is introduced in the second part of lecture 1. In fact, the files in this folder are adapted from the `terraform_with_variables` folder used in that part. Here you need to adapt the fields in `variables.tf` to your project. Specifically for credential, the service account must have at least the relevant GCS and BigQuery permissions. The easiest way is just selecting "GCS Admin" and "BigQuery Admin", but can be more fine-grained. Afterwards, just run
```sh
# Initialize Terraform
terraform init

# To view what you are going to create (optional due to simplicity of this project)
terraform plan

# To apply the changes
terraform apply
```

## Step 2 - 5. Pipeline creation (`pipeline` folder)

The environment is containerized with Docker. Before running `docker-compose up`, there are prerequisite:
- Change `dev.env` to `.env`.
- Add GCP's service account key to the folder. The folder is used as the volume to the container, so the service account key has to be there to be found.

Afterwards, run `docker-compose up` to start developing. There will be 2 pipelines to create

### Change config file

The first step is navigating to Files to change `io_config.yaml` so that we can access 