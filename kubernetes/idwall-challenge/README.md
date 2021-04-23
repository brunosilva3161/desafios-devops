# Usage examples

## Example of how to create idwall challenge deployments:

Creating a production environment with name prod-challenge in helm:

```
helm install --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

## Upgrading a production environment with name prod-challenge in helm:

```
helm upgrade --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

## Rollback a production environment with name prod-challenge to a previous version in helm:

```
helm rollback prod-challenge $DESIRED_REVISION_NUMBER
```

## Above examples with a development environment:

```
helm install --create-namespace --namespace development --set replicas=1,deployment.version=1.0.0,service.port=80,node_app.name="Uiatamara Jhuliene",node_app.address=dev-idwall.challenge.k8s dev-challenge ./idwall-challenge

helm upgrade --create-namespace --namespace development --set replicas=1,deployment.version=1.0.0,service.port=80,node_app.name="Uiatamara Jhuliene",node_app.address=dev-idwall.challenge.k8s dev-challenge ./idwall-challenge

helm rollback dev-challenge $DESIRED_REVISION_NUMBER
```

# References:

* [Using Helm](https://helm.sh/docs/intro/using_helm/)