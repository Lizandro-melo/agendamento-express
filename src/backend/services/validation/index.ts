import { empresa, PrismaClient, proficional, user } from "@/prisma";
import { Twilio } from "twilio";
import { isCNPJ, isCPF } from "validation-br";
import "@/config/env";
import PRISMA from "../db";
import { SendCodeOtp, Twofa } from "@/types/empresa/req";
import { compare, hash } from "bcrypt";
import moment from "moment-timezone";


export class Validar_empresa {
  private empresa: empresa

  constructor(empresa: empresa) {
    this.empresa = empresa
  }

  public get GetEmpresa() {
    return this.empresa
  }

  public async Validar() {
    await this.ValidarCNPJ()
    this.empresa.numero_celular_empresa = this.empresa.numero_celular_empresa.replace(/[.\-\/\(\)\s]/g, "");
    new Validar_celular().isValidBrazilianPhone(this.empresa.numero_celular_empresa)
    return this
  }

  private async ValidarCNPJ() {
    const cnpj_validado = this.empresa.cnpj.replace(/[.\-\/\s]/g, "");
    if (!isCNPJ(cnpj_validado)) throw new Error("CNPJ inválido")
    const result_find_empresa = await PRISMA.empresa.findUnique({
      where: {
        cnpj: cnpj_validado,
      },
    });
    if (result_find_empresa) throw new Error("CNPJ já cadastrado em nosso sistema!")
    this.empresa.cnpj = cnpj_validado
  }
}

export class Validar_proficional {
  private proficional: proficional
  private result_find_proficional: proficional | null = null

  public get isExist(): boolean {
    return this.result_find_proficional ? true : false
  }

  public get GetProficional() {
    return this.proficional
  }

  constructor(proficional: proficional) {
    this.proficional = proficional
  }

  public async Validar() {
    await this.ValidarCPF()
    this.proficional.numero_celular_proficional = this.proficional.numero_celular_proficional.replace(/[.\-\/]/g, "");
    new Validar_celular().isValidBrazilianPhone(this.proficional.numero_celular_proficional)
    return this
  }

  private async ValidarCPF() {

    const cpf_validado = this.proficional.cpf.replace(/[.\-\/\(\)\s]/g, "");

    if (!isCPF(cpf_validado)) throw new Error("CPF inválido")
    this.result_find_proficional = await PRISMA.proficional.findUnique({
      where: {
        cpf: cpf_validado,
      },
    });
    this.proficional.cpf = cpf_validado
  }

}

export class Validar_celular {
  private accountSid: string;
  private authToken: string;
  private regex = /^[1-9]{2}9[0-9]{8}$/;

  constructor() {
    this.accountSid = process.env["SIDTWILIO"] || "";
    this.authToken = process.env["TOKENTWILIO"] || "";

    if (!this.accountSid || !this.authToken) {
      throw new Error("SIDTWILIO ou TOKENTWILIO não definidos nas variáveis de ambiente");
    }
  }

  public isValidBrazilianPhone(phone: string) {
    if (!this.regex.test(phone)) throw new Error("Numero de celular invalido.")
  }

  public async iniciar_validacao({ type, uuid }: Twofa) {
    let user: user | proficional | null = null
    const saltRounds = 10;
    let code = null
    switch (type) {
      case "P":
        user = await PRISMA.proficional.findUnique({
          where: {
            uuid_proficional: uuid
          }
        })
        code = await this.validarNumber(user?.numero_celular_proficional!)
        await PRISMA.proficional.update({
          where: {
            uuid_proficional: uuid
          },
          data: {
            otp_enviado: await hash(code, saltRounds),
            otp_update: moment().tz("America/Sao_Paulo").format()
          }
        })
        break
      case "U":
        user = await PRISMA.user.findUnique({
          where: {
            uuid_user: uuid
          }
        })
        code = await this.validarNumber(user?.numero_celular_user!)
        await PRISMA.user.update({
          where: {
            uuid_user: uuid
          },
          data: {
            otp_enviado: await hash(code, saltRounds),
            otp_update: moment().tz("America/Sao_Paulo").format()
          }
        })
        break
    }

  }

  private async validarNumber(number_celular: string) {
    const client = new Twilio(this.accountSid, this.authToken);
    const CODE_OTP = this.gerarOTP().toString()
    try {
      await client.messages.create({
        from: '+17624753628',
        to: `+55${number_celular}`,
        body: `Seu código de verificação é: ${CODE_OTP}\nEste código é válido por 10 minutos.\nPor segurança, não compartilhe este código com ninguém.`
      });
      return CODE_OTP
    } catch {
      throw new Error("Não foi possivel enviar o codigo, por favor tente novamente mais tarde.")
    }

  }

  private gerarOTP() {
    let otp = '';
    for (let i = 0; i < 6; i++) {
      otp += Math.floor(Math.random() * 10);
    }
    return otp;
  }

  public async verificar_otp({ code, uuid, type }: SendCodeOtp) {
    let user: user | proficional | null = null
    switch (type) {
      case "P":
        user = await PRISMA.proficional.findUnique({
          where: {
            uuid_proficional: uuid
          }
        })
        if (moment().tz("America/Sao_Paulo").diff(moment(user?.otp_update).tz("America/Sao_Paulo"), "minutes") > 10) {
          this.iniciar_validacao({ type, uuid })
          throw new Error("Codigo OTP vencido, reenviamos um novo codigo.")
        }
        const codeOtpDB = user?.otp_enviado
        if (await compare(code, codeOtpDB!)) {
          await PRISMA.proficional.update({
            where: {
              uuid_proficional: uuid
            },
            data: {
              otp_enviado: "",
              otp_update: moment().tz("America/Sao_Paulo").format(),
              validation_celular_proficional: true
            }
          })
        } else {
          throw new Error("Codigo OTP Invalido, tente novamente")
        }
        break
      case "U":
        user = await PRISMA.user.findUnique({
          where: {
            uuid_user: uuid
          }
        })
        code = await this.validarNumber(user?.numero_celular_user!)
        break
    }
  }
}
