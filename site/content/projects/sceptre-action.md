+++
title = "Sceptre GitHub Action"
tags = [
  "bash",
  "python",
  "aws",
  "cloudformation",
  "sceptre",
  "docker"
]
date = "2020-04-23"
toc = true
+++

## TL:DR

I created an open-source GitHub Action that abstracts the underlying steps to spin up a environment for using Sceptre to manage Cloudformation stacks.

You can view the action on the GitHub marketplace [here](https://github.com/marketplace/actions/sceptre-github-action) and the source code can be seen [here](https://github.com/Rurquhart/sceptre-action).

---

## Background

[GitHub Actions](https://github.com/features/actions) is a managed CI/CD pipeline tool that allow developers to define automated workflows in simple yaml configuration files.

To use GitHub actions, you define `workflows` that have a `trigger` (aka on pull request, on tag creation etc) and one or more `jobs` which are a logical grouping of one or more task. The workflow is executed on a virtual machine `runner`.

Like this:

```none
workflow
  ├── trigger
      └── on[merge]
  └── jobs
      └── job1
          ├── task1
          └── task2
```

A feature of GitHub actions that is really useful but not unique is the possibility for anyone to create a public open-source action that abstracts an underlying task (or multiple) and can be simply called when needed. These actions are either executed on the runner via a Docker container or on the runner itself as Javascript.

[Sceptre](https://sceptre.cloudreach.com/2.3.0/) is an open-source tool for managing and deploying Cloudformation stacks. It simplifies stack dependancies, IAM role assumption and deploying full environments containing multiple stacks. It's available as a Python module and a CLI tool.

## Why

One of the most common actions within the CI/CD pipelines I either build or interact with on a daily basis is to update or deploy IaC, either via Terraform or Sceptre/Cloudformation.

Hasicorp themselves provide a [GitHub action](https://github.com/hashicorp/terraform-github-actions) for deploying Terraform IaC but I could find no equivalent for Sceptre. This meant that our workflows across multiple repos contained the same configuration steps for setting up Sceptre and creating an action that enacpsulated these steps for us would be ideal.

Additionally, I was just interested in having a go at creating an action and this interest was amplified by me trying to procastinate studying for my [Azure AZ-400 certificate](https://www.youracclaim.com/badges/4638b2e9-e355-45b8-adbc-605d7d3f2473/linked_in) on the day I created the action.

## Execution

As mentioned previously, Hashicorp provide a Github action for deploying Terraform stacks and from this I knew that I wanted a way to for users to specify which version of Sceptre and the additional Python modules ([Troposphere](https://github.com/cloudtools/troposphere)/[Jinja2](https://github.com/pallets/jinja)) that may be used to create templates.

This would be especially helpful for my usecase of deploying Sceptre stacks to multiple customer environments where each environment could be using a different version of Sceptre/Troposphere.

This meant I couldn't bake all the neccesary Python modules into the Docker image and just publish that. Instead. just like Hashicorp's action, I needed to make use of the required `entrypoint.sh` to install these modules at runtime.

## Afterthoughts

As always, reviewing your own work later down the line makes you realise parts that you could improve and this is no different, whilst I was writing this post I realised that I hadn't actually built out support for Jinja2 templates and that I could actually publish the Docker image (which is just the public python-slim image with my entrypoint.sh added) for faster execution times for workflows making use of this action multiple times.

Additionally, whilst chatting to a colleague about this action, he made the excellent suggestion that I could publish a `latest` release of the action, which would bake the latest versions of Sceptre/Jinja2/Troposphere into a docker image. If users where always happy to run the latest version of these modules, then they would benefit from not having to install them at runtime.

I've raised [issues](https://github.com/Rurquhart/sceptre-action/issues) in the repo to track these improvements.
