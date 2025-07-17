import { empresa, proficional } from "@/prisma";

export type Cadastro = {
  empresa: empresa
  proficional: proficional,
  valor?: number
};

export type Twofa = {
  uuid: string
  type: "P" | "U"
}

export type SendCodeOtp = {
  uuid: string
  code: string
  type: "P" | "U"
}