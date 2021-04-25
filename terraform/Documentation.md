# Guia de uso da solução

## Pré-requisitos

Segue abaixo os pré-requisitos desta solução:

* Para acessar com sucesso a instância EC2 criada pelo terraform, faz-se necessário criar um par de chaves SSH no seu diretório `home` com o nome **idwall-challenge**. O comando abaixo pode ser utilizado:
    * `ssh-keygen -f ~/idwall-challenge -b 4096 -C "idwall challenge"`
* Para utilizar o ansible faz-se necessário preparar o ambiente do Python e também instalar as dependências necessárias do ansible galaxy, para isso execute os comandos abaixo, dentro do diretório `terraform/ansible` deste repositório:
    * `pip install -r python_requirements.txt`.
    * `ansible-galaxy install -r requirements.yml`.

## Criando uma instância com Debian 10 na AWS usando o terraform

Para criar a instância EC2 na AWS do tipo t2.micro primeiramente você deve exportar como variável de ambiente as seguintes credenciais de acesso programático na AWS (utilizar o usuário de sua preferência e que tenham permissão de gerenciar o EC2):

```
export AWS_ACCESS_KEY_ID="VALUE"
export AWS_SECRET_ACCESS_KEY="VALUE"
```

Com as credenciais exportadas, o terraform terá acesso para poder criar a instância na AWS.

Para preparar o terraform, execute o comando abaixo:

```
terraform init
```

Após iniciado com sucesso, execute o comando abaixo para verificar o plano de alterações na AWS ou para já aplicar de fato, os comandos estão dispostos respectivamente na ordem que foram informados.

```
terraform plan
terraform apply
```

Tanto na execução do comando `terraform plan` como `terraform apply` serão solicitados os *input* das variáveis abaixo:
* `ssh_ip_range`: Essa variável irá repassar ao terraform um endereço de IP específico ou um range de endereços IP, como por exemplo `192.168.0.1/32` ou `192.168.0.1/24`. Sempre se lembre de informar a máscara `/32` quando for especificar um único IP.
* `aws_region`: Especifica a região da AWS onde a instância irá subir, como por exemplo `us-east-1`.

Aviso:

Atualmente a AMI do debian 10 (Buster) utilizada no código do terraform só irá funcionar caso a instância seja implementada na região `us-east-1`. Caso a instância venha a ser implementada em outra região, consulte a nome da AMI do tipo AMD64 na página [Debian Buster on Amazon EC2](https://wiki.debian.org/Cloud/AmazonEC2Image/Buster) para a região deseja e ajuste no parâmetro abaixo do arquivo `terraform/terraform/resources.tf`:

```
[...]
resource "aws_instance" "idwall_challenge" {
[...]
  ami                         = "ami-0adb6517915458bdb" # Debian 10 (Buster) AMI - Only works in us-east-1 region.
[...]
```

## Instalando o Docker e o Apache (httpd) em container com o ansible

Para implementar um container com Apache (httpd) no Docker do servidor provisionado na AWS com o terraform, basta inserir o endereço IP público do servidor (informado no final da execução do terraform) no valor da variável `ansible_host` no arquivo `terraform/ansible/hosts.yml` deste repositório.

```
all:
  vars:
    ansible_user: admin
  hosts:
    idwall-challenge:
      ansible_host: {{ INFORMAR O IP PÚBLICO AQUI }}
```

Após isso basta executar o comando abaixo e o servidor Apache estará acessível pela porta 80 do endereço IP público da instância AWS, conforme solicitado no desafio.

```
ansible-playbook --private-key ~/idwall-challenge -i hosts.yml playbooks/apache.yml
```

## Endereços de referência:

* [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/#set-up-the-repository)
* [community.docker.docker_container – manage docker containers](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html#ansible-collections-community-docker-docker-container-module)

# Processo de resolução do desafio

Segue abaixo o meu processo de resolução deste desafio:

* Como já havia trabalhado antes com o ansible e o terraform me baseei em códigos que já havia desenvolvido, adaptando-os para os requisitos deste desafio.
* Quando as execuções do código que eu havia desenvolvido falharam, eu buscava compreender claramente o motivo do erro consultando o traceback, e aplicava uma solução (encontrada em documentações, pesquisas do Google ou pelo meu próprio conhecimento teórico e/ou prático).
* Buscava adequar o código de modo a torná-lo o mais simples possível, legível e ao mesmo tempo contemplando boas práticas para o ambiente de produção, como por exemplo não executar o ansible utilizando o usuário root mas sim o método `become`.