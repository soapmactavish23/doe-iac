# doe-iac

Infraestrutura como código do projeto **DOE**, utilizando Terraform e AWS.

## Ambientes

Os ambientes são controlados através de **Terraform Workspaces**:

- `dev`
- `uat`
- `prod`

O ambiente atual é obtido através de:

```hcl
terraform.workspace
```

Portanto, antes de executar `plan` ou `apply`, sempre confirme o workspace selecionado.

---

## 1. Inicializar o Terraform

Na primeira execução:

```bash
terraform init
```

Após alterações de provider ou atualização de dependências:

```bash
terraform init -upgrade
```

---

## 2. Listar os ambientes

```bash
terraform workspace list
```

O workspace marcado com `*` é o ambiente atualmente selecionado.

Exemplo:

```text
  default
* dev
  uat
  prod
```

---

## 3. Criar os workspaces

Execute apenas caso os ambientes ainda não existam:

```bash
terraform workspace new dev
terraform workspace new uat
terraform workspace new prod
```

---

# Selecionar ambiente

## DEV

```bash
terraform workspace select dev
```

## UAT

```bash
terraform workspace select uat
```

## PROD

```bash
terraform workspace select prod
```

Sempre confirme antes de continuar:

```bash
terraform workspace show
```

---

# Fluxo para alterações

Sempre que houver alteração em:

```text
parameters.csv
parameter-store.tf
iam.tf
iam-policy.tf
s3.tf
locals.tf
providers.tf
variables.tf
versions.tf
```

execute:

```bash
terraform fmt -recursive
terraform validate
```

Em seguida selecione o ambiente desejado.

---

# DEV

Selecionar:

```bash
terraform workspace select dev
```

Confirmar:

```bash
terraform workspace show
```

Gerar o plano:

```bash
terraform plan -out=dev.tfplan
```

Revisar:

```bash
terraform show dev.tfplan
```

Aplicar exatamente o plano gerado:

```bash
terraform apply dev.tfplan
```

---

# UAT

Selecionar:

```bash
terraform workspace select uat
```

Confirmar:

```bash
terraform workspace show
```

Gerar:

```bash
terraform plan -out=uat.tfplan
```

Revisar:

```bash
terraform show uat.tfplan
```

Aplicar:

```bash
terraform apply uat.tfplan
```

---

# PROD

Selecionar:

```bash
terraform workspace select prod
```

Confirmar:

```bash
terraform workspace show
```

Gerar:

```bash
terraform plan -out=prod.tfplan
```

Revisar cuidadosamente:

```bash
terraform show prod.tfplan
```

Aplicar:

```bash
terraform apply prod.tfplan
```

> ⚠️ Antes de qualquer `apply` em produção, confirme que o workspace atual é `prod` e revise completamente o `plan`.

---

# Alteração dos Parameters

Os parâmetros do AWS Systems Manager Parameter Store são definidos no arquivo:

```text
parameters.csv
```

O Terraform carrega esse arquivo utilizando:

```hcl
csvdecode(file("${path.module}/parameters.csv"))
```

Sempre que um parâmetro for:

- adicionado;
- alterado;
- removido;

é necessário gerar um novo `plan` para o ambiente correspondente.

Exemplo para DEV:

```bash
terraform workspace select dev

terraform fmt -recursive
terraform validate

terraform plan -out=dev.tfplan

terraform show dev.tfplan

terraform apply dev.tfplan
```

Depois, caso a alteração também precise subir para UAT:

```bash
terraform workspace select uat
terraform workspace show

terraform plan -out=uat.tfplan
terraform show uat.tfplan
terraform apply uat.tfplan
```

E posteriormente PROD:

```bash
terraform workspace select prod
terraform workspace show

terraform plan -out=prod.tfplan
terraform show prod.tfplan
terraform apply prod.tfplan
```

---

# Fluxo recomendado entre ambientes

O fluxo recomendado é:

```text
Alteração
   ↓
DEV
   ↓
terraform plan
   ↓
terraform apply
   ↓
Validação
   ↓
UAT
   ↓
terraform plan
   ↓
terraform apply
   ↓
Homologação
   ↓
PROD
   ↓
terraform plan
   ↓
Revisão
   ↓
terraform apply
```

---

# Comandos rápidos

## Ver ambiente atual

```bash
terraform workspace show
```

## Listar ambientes

```bash
terraform workspace list
```

## Trocar para DEV

```bash
terraform workspace select dev
```

## Trocar para UAT

```bash
terraform workspace select uat
```

## Trocar para PROD

```bash
terraform workspace select prod
```

## Validar

```bash
terraform fmt -recursive
terraform validate
```

## Gerar plan

```bash
terraform plan
```

## Ver recursos gerenciados

```bash
terraform state list
```

## Ver outputs

```bash
terraform output
```

---

# ⚠️ Cuidados

Nunca execute diretamente:

```bash
terraform apply
```

sem antes verificar:

```bash
terraform workspace show
```

e gerar/revisar:

```bash
terraform plan -out=<ambiente>.tfplan
terraform show <ambiente>.tfplan
```

Principalmente no ambiente `prod`.
