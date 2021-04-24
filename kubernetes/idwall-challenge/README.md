# Guia de uso da solução

## Pré-requisitos

Segue abaixo os pré-requisitos desta solução:

* Realizar o build do Dockerfile presente no diretório Kubernetes deste repositório por meio do comando abaixo. Com isso, a imagem utilizada no deployment do Kubernetes ficará disponível.
    * `docker build -t challenge-app:$VERSAO_DESEJADA -f Dockerfile $(pwd)`
* A instalação do Nginx Ingress Controller faz-se necessária para o correto funcionamento do balanceamento de carga entre os pods do deployment. Mais detalhes de como instalar o controlador podem ser visto na página [Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/).
* A instalação do Helm também faz-se necessária para o correto funcionamento desta solução. Mais detalhes de como instalar o Helm podem ser visto na página [Installing Helm](https://helm.sh/docs/intro/install/).
## Iniciando a aplicação do desafio da idwall com o Helm

Para criar um deployment em um namespace de produção com o nome prod-challenge como o helm utilize o comando abaixo (a partir do diretório `kubernetes` deste repositório):

```
helm install --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

Caso o deployment já esteja criado no entando se deseja atualizar algum dado o comando utilizado deve ser o `helm upgrade` como exemplificado abaixo:

```
helm upgrade --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

Por fim, caso se deseje realizar um rollback (*downgrade*) para uma revisão anterior do deployment com o Helm o comando utilizado deve ser o abaixo:

```
helm rollback prod-challenge $NUMERO_DA_VERSAO_DESEJADA
```

## Descrição das variáveis passadas via linha de comando

* `namespace`: Nome do namespace do Kubernetes onde a aplicação node deste desafio irá executar.
* `replicas`: Quantidade de réplicas que serão implementado no deployment.
* `deployment.version`: Versão da imagem do app do desafio devops disponibilizado pela idwall. Para descobrir qual a versão a ser utilizada, execute o comando `docker images ls` e identifique a tag da imagem.
* `service.port`: Porta na qual o servidor node irá receber as requisições do balenceador de cargas do Kubernetes (ingress).
* `node_app.name`: Nome do canditado que será exibido pela aplicação node deste desafio ao acessar o endereço descrito na variável `node_app.address` atráves da porta descrita na variável `service.port`.
* `node_app.address`: Endereço de acesso web que será utilizado no balanceador de carga do Kubernetes (ingress). Caso você não deseje ou não possa criar o nome DNS em um servidor, poderá configurá-lo no arquivo `/etc/hosts` do seu computador, no caso de sistemas operacionais MacOS ou GNU/Linux)

# Endereços de referência:

* [Using Helm](https://helm.sh/docs/intro/using_helm/)