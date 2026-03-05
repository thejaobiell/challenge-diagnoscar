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

import br.com.fiap.model.bo.PecaBO;
import br.com.fiap.model.vo.PecaVO;

@Path("/pecas")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PecaResource {

    private PecaBO pecaBO;

    public PecaResource() throws ClassNotFoundException, SQLException {
        pecaBO = new PecaBO();
    }

    @POST
    public Response cadastrarPeca(PecaVO peca, @Context UriInfo uriInfo) throws SQLException {
        String result = pecaBO.cadastrarPeca(peca);
        UriBuilder builder = uriInfo.getAbsolutePathBuilder();
        builder.path(peca.getIdPeca());
        return Response.created(builder.build()).entity(result).build();
    }

    @GET
    public List<PecaVO> listarPecas() throws SQLException {
        return pecaBO.listarPecas();
    }

    @PUT
    @Path("/{idPeca}")
    public Response atualizarPeca(PecaVO peca, @PathParam("idPeca") String idPeca) throws SQLException {
        peca.setIdPeca(idPeca);
        String result = pecaBO.atualizarPeca(peca);
        return Response.ok(result).build();
    }

    @DELETE
    @Path("/{idPeca}")
    public Response deletarPeca(@PathParam("idPeca") String idPeca) throws SQLException {
        String result = pecaBO.deletarPeca(idPeca);
        return Response.ok(result).build();
    }
}