export type response_gateway = {
  data: {
    id: string,
    url: string,
    amount: number,
    status: string,
    devMode: boolean,
    methods: string,
    frequency: string,
    nextBilling: any,
    customer: {
      id: string,
      metadata: {
        email: string
      }
    },
    createdAt: string,
    updatedAt: string,
  },
  error: null
}