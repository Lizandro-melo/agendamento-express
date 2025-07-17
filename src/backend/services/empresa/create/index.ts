import { Validar_empresa, Validar_proficional } from "@/backend/services/validation";
import { Cadastro } from "@/types/empresa/req";
import { empresa, proficional } from "@/prisma";
import { log } from "console";
import { hash } from "bcrypt"
import PRISMA from "@/backend/services/db";
import abacate from "@/backend/services/abacate";
import moment from "moment";

export class Register_empresa {
  private empresa: empresa
  private proficional: proficional
  private empresa_validada: Validar_empresa | null = null
  private proficional_validado: Validar_proficional | null = null
  private valor: number = 20000

  constructor({ empresa, proficional, valor }: Cadastro) {
    this.empresa = empresa
    this.proficional = proficional
    this.valor = valor || 20000
  }

  public async Registrar() {
    this.empresa_validada = await new Validar_empresa(this.empresa).Validar()
    this.proficional_validado = await new Validar_proficional(this.proficional).Validar()
    if (this.valor < 10000) throw new Error("Não foi possivel efetuar o cadastro com esse valor!")
    let proficional = null
    const empresa_criada = await PRISMA.empresa.create({
      data: {
        nome_empresa: this.empresa_validada.GetEmpresa.nome_empresa,
        numero_celular_empresa: this.empresa_validada.GetEmpresa.numero_celular_empresa,
        numero_telefone_empresa: this.empresa_validada.GetEmpresa.numero_telefone_empresa,
        email_empresa: this.empresa_validada.GetEmpresa.email_empresa,
        cnpj: this.empresa_validada.GetEmpresa.cnpj,
        plano_pagamento: this.empresa_validada.GetEmpresa.plano_pagamento,
        valor_pagamento: this.valor
      }
    })

    if (!this.proficional_validado.isExist) {
      const saltRounds = 10;
      const hashedPassword = await hash(this.proficional_validado.GetProficional.senha, saltRounds);
      proficional = await PRISMA.proficional.create({
        data: {
          nome_proficional: this.proficional_validado.GetProficional.nome_proficional,
          cpf: this.proficional_validado.GetProficional.cpf,
          numero_celular_proficional: this.proficional_validado.GetProficional.numero_celular_proficional,
          email_proficional: this.proficional_validado.GetProficional.email_proficional,
          senha: hashedPassword,
        }
      })
    } else {
      proficional = await PRISMA.proficional.findUnique({
        where: {
          cpf: this.proficional_validado.GetProficional.cpf
        }
      })
    }
    await PRISMA.empresa_proficional.create({
      data: {
        uuid_empresa: empresa_criada.uuid_empresa,
        uuid_proficional: proficional!.uuid_proficional,
      }
    })
    // Abacate criar cliente
    const abacate_cliente = await abacate.customer.create({
      name: empresa_criada.nome_empresa,
      email: empresa_criada.email_empresa,
      cellphone: empresa_criada.numero_celular_empresa,
      taxId: proficional?.cpf
    }).then(response => response)
    try {

      if (empresa_criada.plano_pagamento === "MENSAL") {
        for (let i = 0; i < 2; i++) {
          if (i !== 0) {
            const abacate_pagamento = await abacate.billing.create({
              frequency: "ONE_TIME",
              methods: ["PIX"],
              products: [
                {
                  externalId: "prod-001",
                  name: "Assinatura do Agendamento Expresso",
                  description: "Acesso a plataforma de agendamento, permitindo assim o acesso dos cliente, do pagador à plataforma",
                  quantity: 1,
                  price: this.valor
                }
              ],
              customerId: abacate_cliente.data?.id!,
              customer: abacate_cliente.data?.metadata!,
              returnUrl: "https://example.com/billing",
              completionUrl: "https://example.com/completion"
            }).then(response => response)

            await PRISMA.pagamento.create({
              data: {
                link: abacate_pagamento.data?.url!,
                metodo_pagamento: abacate_pagamento.data?.methods[0]!,
                valor: abacate_pagamento.data?.amount!,
                data_vencimento: moment().tz("America/Sao_Paulo").month(moment().month() === 12 ? 1 : moment().month() + 1 + i).format(),
                uuid_empresa: empresa_criada.uuid_empresa,
                pago: abacate_pagamento.data?.status!,
              }
            })
          } else {
            await PRISMA.pagamento.create({
              data: {
                link: "",
                metodo_pagamento: "GRATIS",
                valor: 0,
                data_vencimento: moment().tz("America/Sao_Paulo").month(moment().month() === 12 ? 1 : moment().month() + 1 + i).format(),
                uuid_empresa: empresa_criada.uuid_empresa,
                pago: "COMPLETED",
              }
            })
          }
        }
      } else if (empresa_criada.plano_pagamento === "ANUAL") {
        for (let i = 0; i < 12; i++) {
          if (i !== 0) {
            const abacate_pagamento = await abacate.billing.create({
              frequency: "ONE_TIME",
              methods: ["PIX"],
              products: [
                {
                  externalId: "prod-001",
                  name: "Assinatura do Agendamento Expresso",
                  description: "Acesso a plataforma de agendamento, permitindo assim o acesso dos cliente, do pagador à plataforma",
                  quantity: 1,
                  price: this.valor
                }
              ],
              customerId: abacate_cliente.data?.id!,
              customer: abacate_cliente.data?.metadata!,
              returnUrl: "https://example.com/billing",
              completionUrl: "https://example.com/completion"
            }).then(response => response)

            await PRISMA.pagamento.create({
              data: {
                link: abacate_pagamento.data?.url!,
                metodo_pagamento: abacate_pagamento.data?.methods[0]!,
                valor: abacate_pagamento.data?.amount!,
                data_vencimento: moment().tz("America/Sao_Paulo").month(moment().month() === 12 ? 1 : moment().month() + 1 + i).format(),
                uuid_empresa: empresa_criada.uuid_empresa,
                pago: abacate_pagamento.data?.status!,
              }
            })
          } else {
            await PRISMA.pagamento.create({
              data: {
                link: "",
                metodo_pagamento: "GRATIS",
                valor: 0,
                data_vencimento: moment().tz("America/Sao_Paulo").month(moment().month() === 12 ? 1 : moment().month() + 1 + i).format(),
                uuid_empresa: empresa_criada.uuid_empresa,
                pago: "COMPLETED",
              }
            })
          }
        }
      } else {
        throw new Error("Não foi possivel cadastrar sua empresa.")
      }
    } catch (err: any) {
      throw new Error(err.message);
    }
  }
}