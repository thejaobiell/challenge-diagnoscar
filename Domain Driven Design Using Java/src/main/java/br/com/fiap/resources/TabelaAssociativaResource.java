package br.com.fiap.resources;

import java.sql.SQLException;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriBuilder;
import javax.ws.rs.core.UriInfo;

import br.com.fiap.model.bo.TabelaAssociativaBO;
import br.com.fiap.model.vo.TabelaAssociativaVO;

@Path("/tabelaAssociativa")
public class TabelaAssociativaResource {

    private TabelaAssociativaBO tabelaAssociativaBO;

    public TabelaAssociativaResource() throws ClassNotFoundException, SQLException {
        tabelaAssociativaBO = new TabelaAssociativaBO();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response cadastrar(TabelaAssociativaVO tabelaAssociativa, @Context UriInfo uriInfo) throws SQLException {
        tabelaAssociativaBO.cadastrarTabelaAssociativa(tabelaAssociativa);
        UriBuilder builder = uriInfo.getAbsolutePathBuilder();
        builder.path(String.valueOf(tabelaAssociativa.getCpfCliente()));
        return Response.created(builder.build()).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<TabelaAssociativaVO> listar() throws SQLException {
        return null;
    }

    @PUT
    @Path("/{cpfCliente}/{idChatbot}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response atualizar(@PathParam("cpfCliente") String cpfCliente, @PathParam("idChatbot") String idChatbot, TabelaAssociativaVO tabelaAssociativa) throws SQLException {
        tabelaAssociativa.setCpfCliente(cpfCliente);
        tabelaAssociativa.setIdChatbot(idChatbot);
        tabelaAssociativaBO.atualizarTabelaAssociativa(tabelaAssociativa);
        return Response.ok().build();
    }

    @DELETE
    @Path("/{cpfCliente}/{idChatbot}")
    public Response deletar(@PathParam("cpfCliente") String cpfCliente, @PathParam("idChatbot") String idChatbot) throws SQLException {
        tabelaAssociativaBO.deletarTabelaAssociativa(cpfCliente, idChatbot);
        return Response.ok().build();
    }
}