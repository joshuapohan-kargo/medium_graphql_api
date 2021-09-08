defmodule MediumGraphqlApiWeb.Plugs.Context do
    @behaviour Plug

    import Plug.Conn

    def init(opts) do
        opts
    end 

    def call(conn, _) do
        context = build_context(conn)
        Absinthe.Plug.put_options(conn, context: context)
    end

    defp build_context(conn) do
        with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
            {:ok,claims} <- MediumGraphqlApi.Guardian.decode_and_verify(token),
            {:ok,user} <- MediumGraphqlApi.Guardian.resource_from_claims(claims) do
            user
        else
            _ -> %{}
        end
    end
end