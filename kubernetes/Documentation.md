# Guia de uso da solução

## Pré-requisitos

Segue abaixo os pré-requisitos desta solução:

* Realizar o build do Dockerfile presente no diretório Kubernetes deste repositório por meio do comando abaixo. Com isso, a imagem utilizada no deployment do Kubernetes ficará disponível.
    * `docker build -t challenge-app:$VERSAO_DESEJADA -f Dockerfile $(pwd)`
* A instalação do Nginx Ingress Controller faz-se necessária para o correto funcionamento do balanceamento de carga entre os pods do deployment. Mais detalhes de como instalar o controlador podem ser vistos na página [Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/).
* A instalação do Helm também faz-se necessária para o correto funcionamento desta solução. Mais detalhes de como instalar o Helm podem ser visto na página [Installing Helm](https://helm.sh/docs/intro/install/).
## Iniciando a aplicação do desafio da idwall com o Helm

Para criar um deployment em um namespace de produção com o nome prod-challenge como o helm utilize o comando abaixo (a partir do diretório `kubernetes` deste repositório):

```
helm install --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

Caso o deployment já esteja criado no entanto se deseja atualizar algum dado o comando utilizado deve ser o `helm upgrade` como exemplificado abaixo:

```
helm upgrade --create-namespace --namespace production --set replicas=3,deployment.version=1.0.0,service.port=80,node_app.name="Bruno Silva",node_app.address=prod-idwall.challenge.k8s prod-challenge ./idwall-challenge
```

Por fim, caso se deseje realizar um rollback (*downgrade*) para uma revisão anterior do deployment com o Helm o comando utilizado deve ser o abaixo:

```
helm rollback prod-challenge $NUMERO_DA_VERSAO_DESEJADA
```

## Descrição das variáveis passadas via linha de comando

* `namespace`: Nome do namespace do Kubernetes onde a aplicação node deste desafio irá executar.
* `replicas`: Quantidade de réplicas que serão implementadas no deployment.
* `deployment.version`: Versão da imagem do app do desafio devops disponibilizado pela idwall. Para descobrir qual a versão a ser utilizada, execute o comando `docker images ls` e identifique a tag da imagem.
* `service.port`: Porta na qual o servidor node irá receber as requisições do balanceador de cargas do Kubernetes (ingress).
* `node_app.name`: Nome do candidato que será exibido pela aplicação node deste desafio ao acessar o endereço descrito na variável `node_app.address` através da porta descrita na variável `service.port`.
* `node_app.address`: Endereço de acesso web que será utilizado no balanceador de carga do Kubernetes (ingress). Caso você não deseje ou não possa criar o nome DNS em um servidor, poderá configurá-lo no arquivo `/etc/hosts` do seu computador, no caso de sistemas operacionais MacOS ou GNU/Linux)

## Endereços de referência:

* [Using Helm](https://helm.sh/docs/intro/using_helm/)

# Processo de resolução do desafio

Segue abaixo o meu processo de resolução deste desafio:

* Durante minha vida acadêmica e profissional tive a oportunidade de conhecer e trabalhar bem com containers Docker, o que me ajudou muito principalmente no entendimento dos conceitos e boas práticas para essa tecnologia. Devido a isso já havia tido contato prévio com:
    * Criação de `Dockerfile`.
    * Build de container.
    * Orquestração de containers por meio do Docker Compose.
    * Gerenciamento de container por meio do Portainer.
    * Gerenciamento de container por meio do Docker Swarm, o qual possui muitos conceitos que vi novamente no Kubernetes.
* Como a realização deste desafio foi meu primeiro grande contato com o Kubernetes, para aprender e entender os conceitos me baseei em fontes de conhecimento que foram de inestimável valor, foram elas:
    * O livro [Kubernetes Básico](https://novatec.com.br/livros/kubernetes-basico/) da O'Reilly.
    * A [documentação do Kubernetes](https://kubernetes.io/docs/home/) em inglês.
    * Páginas da internet com exemplos mais simples de uso do Kubernetes ou mesmo do Helm, como foi o caso deste artigo do blog da [Movile](https://movile.blog/empacotando-aplicacoes-kubernetes-com-helm/) onde aprendi mais sobre o Helm.
    * A documentação do [Helm](https://helm.sh/docs/).
* Para criar o código que implementou no Kubernetes a aplicação node deste desafio, realizei os seguintes passos:
    * Após entender a conceito dos manifestos de um deployment, replicaset, service, ingress e configmap começei a com base nos exemplos da própria documentação do Kubernetes adaptar para a necessidade deste desafio e realizar os testes em um Kubernetes instalado no Docker for Mac.
    * Após validar o correto funcionamento e entendimento dos conceitos do Kubernetes, "migrei" esse código para os templates do Helm e novamente realizei testes com o Helm para entender e solidificar o conhecimento adquirido com a ferramenta.
    * Optei pela simplicidade ao desenvolver essa solução para o desafio, uma vez que a aplicação em node entregue é simples e não exige um cenário mais completo (com armazenamento persistente, por exemplo). Embora tenha optado por essa simplicidade, busquei seguir boas práticas de um ambiente de produção, conforme me foi orientado.