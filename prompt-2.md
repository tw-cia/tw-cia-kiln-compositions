# Kiln Infrastructure

This is a directory with a "kiln" project. I want a set of new XRDs that ...

- Spin up an auto-scaling group
- with a launch template
- create a load balancer with the auto-scaling group
- create an acm certificate, and validate using dns
- a cloudfront distribution to front our load balancer

The launch template should allow the user to specify a user-data script so we can bootstrap the instance however we want.

Use kiln reccomended practices. Write tests.
