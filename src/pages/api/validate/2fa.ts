
import { proficional, user } from "@/prisma";
import { SendCodeOtp, Twofa } from "@/types/empresa/req";
import PRISMA from "@/backend/services/db";
import { Validar_celular } from "@/backend/services/validation";
import type { NextApiRequest, NextApiResponse } from "next";

export default async function auth_2fa(req: NextApiRequest, res: NextApiResponse) {
  try {

    if (req.method === "GET") {
      const { type, uuid }: Twofa = req.body
      await new Validar_celular().iniciar_validacao({ type, uuid })
      res.status(200).json({ mensagem: "Codigo enviado!" })
    } else if (req.method === "POST") {
      const { code, uuid, type }: SendCodeOtp = req.body
      await new Validar_celular().verificar_otp({ code, uuid, type })
      res.status(200).json({ mensagem: "Numero de celular verificado" })
    } else {
      res.status(405).json({ mensagem: "Metodo invalido" });
    }
  } catch (error: any) {
    res.status(400).send({ mensagem: error.message })
  }
}
