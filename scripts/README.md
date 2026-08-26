# DevOps Intern Final Assessment

**Name:** Krishnakanthula Shivamani  
**Date:** 20 August 2026

## Project Description

This repository is a small, end-to-end DevOps pipeline built as a final
assessment project. It walks through Git/GitHub basics, Linux scripting,
Docker containerization, CI/CD with GitHub Actions, job scheduling with
HashiCorp Nomad, and log monitoring with Grafana Loki — with each step
producing output the next step depends on.

![CI](https://github.com/shivamani3286-cloud/devops-intern-final/actions/workflows/ci.yml/badge.svg)

---

## 1. Git & GitHub Setup

Repo initialized with this README and a sample script (`hello.py`) that
prints `Hello, DevOps!`.

```bash
python hello.py
```

---

## 2. Linux & Scripting Basics

`scripts/sysinfo.sh` prints the current user, current date, and disk usage.

Run it:

```bash
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh
```

---

## 3. Docker Basics

`Dockerfile` containerizes `hello.py` using a slim Python 3.11 base image.

Build and run:

```bash
docker build -t hello-devops:latest .
docker run --rm hello-devops:latest
```

Expected output:

```text
Hello, DevOps!
```

![Docker run output](https://raw.githubusercontent.com/shivamani3286-cloud/devops-intern-final/main/screenshots/docker-run.png)

---

## 4. CI/CD with GitHub Actions

`.github/workflows/ci.yml` runs `python hello.py` automatically on every
push and pull request to `main`. Status badge is at the top of this
README.

---

## 5. Job Deployment with Nomad

`nomad/hello.nomad` runs the `hello-devops:latest` Docker image as a
Nomad service job with minimal resources (100 MHz CPU, 128 MB memory).

Run it (assumes a local Nomad dev agent and Docker driver):

```bash
# start a local dev agent in one terminal
sudo nomad agent -dev

# build the image so the local docker driver can find it
docker build -t hello-devops:latest .

# submit the job in another terminal
nomad job run nomad/hello.nomad

# check status / logs
nomad job status hello
nomad alloc logs <alloc-id>
```

---

## 6. Monitoring with Grafana Loki

Loki, Grafana, and the Loki Docker logging driver were run on an AWS EC2
instance to collect and view Docker container logs.

### Start Loki and Grafana

```bash
cd monitoring
docker-compose up -d
```

### Install the Loki Docker logging driver

```bash
docker plugin install grafana/loki-docker-driver:latest \
  --alias loki --grant-all-permissions
```

### Run the application with Loki logging

Build the application image:

```bash
docker build -t hello-devops:latest .
```

Run the container with Loki logging:

```bash
docker run --rm --name hello-devops \
  --log-driver=loki \
  --log-opt loki-url="http://localhost:3100/loki/api/v1/push" \
  --log-opt loki-external-labels="job=hello-devops,container_name={{.Name}}" \
  hello-devops:latest
```

Expected output:

```text
Hello, DevOps!
```

### Verify logs in Loki

```bash
curl -G -s "http://localhost:3100/loki/api/v1/query" \
  --data-urlencode 'query={job="hello-devops"}'
```

The query returns the `Hello, DevOps!` log entry with the
`job="hello-devops"` label.

### View logs in Grafana

Open Grafana and select the Loki data source in **Explore**.

Use the following query:

```logql
{job="hello-devops"}
```

The query displays the `Hello, DevOps!` container logs collected by Loki.

![Grafana Explore logs](https://raw.githubusercontent.com/shivamani3286-cloud/devops-intern-final/main/screenshots/grafana-explore.png)


---

## 7. Extra Credit (Optional)

Not implemented in this submission. Potential next steps: add
`mlflow/` with a dummy experiment run, or a `vm/` folder documenting a
VirtualBox VM running the same Docker/Nomad job.

---

## Repository Structure

```text
devops-intern-final/
├── README.md
├── hello.py
├── Dockerfile
├── scripts/
│   └── sysinfo.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── nomad/
│   └── hello.nomad
├── monitoring/
│   ├── docker-compose.yml
│   ├── promtail-config.yml
│   └── loki_setup.txt
└── screenshots/
    ├── docker-run.png
    └── grafana-explore.png
```
