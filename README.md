vagrant-elasticsearch-puppet
============================

Creates a multi-node elasticsearch cluster using Vagrant and puppet

In order to create more nodes, edit the Vagrantfile for server count

``` 
server_count = 2
```

Current ElasticSearch version used is 1.3 based on the Elasticsearch supported Repo for Centos

### Usage

```
vagrant up
curl localhost:9200 
```
*Note that if multiple nodes have been created, they will be forwarded to localhost:9201, localhost:9202, etc.*
