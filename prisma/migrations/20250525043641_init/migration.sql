-- CreateEnum
CREATE TYPE "Metodo_pagamento" AS ENUM ('PIX', 'CRED', 'DEB');

-- CreateTable
CREATE TABLE "User" (
    "uuid_user" TEXT NOT NULL,
    "name_user" TEXT NOT NULL,
    "numero_celular_user" TEXT NOT NULL,
    "email" TEXT,
    "login" TEXT,
    "senha" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "alterado" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("uuid_user")
);

-- CreateTable
CREATE TABLE "Empresa" (
    "uuid_empresa" TEXT NOT NULL,
    "nome_dono" TEXT NOT NULL,
    "email_dono" TEXT NOT NULL,
    "numero_celular_dono" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "nome_empresa" TEXT NOT NULL,
    "redes" JSONB,
    "numero_celular_empresa" TEXT NOT NULL,
    "numero_telefone_empresa" TEXT,
    "logo_empresa" TEXT,
    "cpf_dono" TEXT NOT NULL,
    "cnpj_empresa" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "alterado" TIMESTAMP(3),
    "plano_pagamento" TEXT,
    "dias_tolerancia" INTEGER NOT NULL DEFAULT 7,

    CONSTRAINT "Empresa_pkey" PRIMARY KEY ("uuid_empresa")
);

-- CreateTable
CREATE TABLE "User_empresa" (
    "id" SERIAL NOT NULL,
    "uuid_user" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "User_empresa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Servico_principais" (
    "uuid_servico_principal" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "logo" TEXT,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "empresa_uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "Servico_principais_pkey" PRIMARY KEY ("uuid_servico_principal")
);

-- CreateTable
CREATE TABLE "Subservico" (
    "uuid_subservico" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "valor" DECIMAL(65,30) NOT NULL,
    "descricao" TEXT,
    "duracao" TIMESTAMP(3) NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "uuid_servico_principal" TEXT NOT NULL,

    CONSTRAINT "Subservico_pkey" PRIMARY KEY ("uuid_subservico")
);

-- CreateTable
CREATE TABLE "Servico_add" (
    "uuid_servico_add" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "valor" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "duracao" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Servico_add_pkey" PRIMARY KEY ("uuid_servico_add")
);

-- CreateTable
CREATE TABLE "Agendamento" (
    "uuid_agendamento" TEXT NOT NULL,
    "uuid_subservico" TEXT NOT NULL,
    "valor_total" DECIMAL(65,30) NOT NULL,
    "duracao" TIMESTAMP(3) NOT NULL,
    "data_agendamento" TIMESTAMP(3) NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "metodo_pagamento" "Metodo_pagamento",
    "token_pagamento" TEXT,
    "ultimo_numero_cartao" TEXT,
    "uuid_user" TEXT NOT NULL,
    "chave_pix" TEXT,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Agendamento_pkey" PRIMARY KEY ("uuid_agendamento")
);

-- CreateTable
CREATE TABLE "Agendamento_servico" (
    "id" SERIAL NOT NULL,
    "uuid_servico_add" TEXT NOT NULL,
    "uuid_agendamento" TEXT NOT NULL,

    CONSTRAINT "Agendamento_servico_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pagamento" (
    "uuid_pagamento" TEXT NOT NULL,
    "uuid_empresa" TEXT NOT NULL,
    "pago" BOOLEAN NOT NULL DEFAULT false,
    "valor" TEXT NOT NULL,
    "metodo_pagamento" "Metodo_pagamento" NOT NULL,
    "ultimo_numero_cartao" TEXT,
    "chave_pix" TEXT,
    "token_pagamento" TEXT,
    "criado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_vencimento" TIMESTAMP(3),

    CONSTRAINT "Pagamento_pkey" PRIMARY KEY ("uuid_pagamento")
);

-- CreateTable
CREATE TABLE "Disponibilidade" (
    "id" SERIAL NOT NULL,
    "data_hora" TIMESTAMP(3) NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "uuid_empresa" TEXT NOT NULL,

    CONSTRAINT "Disponibilidade_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_uuid_user_key" ON "User"("uuid_user");

-- CreateIndex
CREATE UNIQUE INDEX "Empresa_uuid_empresa_key" ON "Empresa"("uuid_empresa");

-- CreateIndex
CREATE UNIQUE INDEX "Servico_principais_uuid_servico_principal_key" ON "Servico_principais"("uuid_servico_principal");

-- CreateIndex
CREATE UNIQUE INDEX "Subservico_uuid_subservico_key" ON "Subservico"("uuid_subservico");

-- CreateIndex
CREATE UNIQUE INDEX "Servico_add_uuid_servico_add_key" ON "Servico_add"("uuid_servico_add");

-- CreateIndex
CREATE UNIQUE INDEX "Agendamento_uuid_agendamento_key" ON "Agendamento"("uuid_agendamento");

-- CreateIndex
CREATE UNIQUE INDEX "Agendamento_servico_id_key" ON "Agendamento_servico"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Pagamento_uuid_pagamento_key" ON "Pagamento"("uuid_pagamento");

-- CreateIndex
CREATE UNIQUE INDEX "Disponibilidade_id_key" ON "Disponibilidade"("id");

-- AddForeignKey
ALTER TABLE "User_empresa" ADD CONSTRAINT "User_empresa_uuid_user_fkey" FOREIGN KEY ("uuid_user") REFERENCES "User"("uuid_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_empresa" ADD CONSTRAINT "User_empresa_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "Empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Servico_principais" ADD CONSTRAINT "Servico_principais_empresa_uuid_empresa_fkey" FOREIGN KEY ("empresa_uuid_empresa") REFERENCES "Empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subservico" ADD CONSTRAINT "Subservico_uuid_servico_principal_fkey" FOREIGN KEY ("uuid_servico_principal") REFERENCES "Servico_principais"("uuid_servico_principal") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento" ADD CONSTRAINT "Agendamento_uuid_user_fkey" FOREIGN KEY ("uuid_user") REFERENCES "User"("uuid_user") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento" ADD CONSTRAINT "Agendamento_uuid_subservico_fkey" FOREIGN KEY ("uuid_subservico") REFERENCES "Subservico"("uuid_subservico") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento_servico" ADD CONSTRAINT "Agendamento_servico_uuid_servico_add_fkey" FOREIGN KEY ("uuid_servico_add") REFERENCES "Servico_add"("uuid_servico_add") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento_servico" ADD CONSTRAINT "Agendamento_servico_uuid_agendamento_fkey" FOREIGN KEY ("uuid_agendamento") REFERENCES "Agendamento"("uuid_agendamento") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pagamento" ADD CONSTRAINT "Pagamento_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "Empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Disponibilidade" ADD CONSTRAINT "Disponibilidade_uuid_empresa_fkey" FOREIGN KEY ("uuid_empresa") REFERENCES "Empresa"("uuid_empresa") ON DELETE RESTRICT ON UPDATE CASCADE;
