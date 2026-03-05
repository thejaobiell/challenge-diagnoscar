package br.com.fiap.resources;

import br.com.fiap.model.bo.PreDiagnosticoBO;
import br.com.fiap.model.vo.PreDiagnosticoVO;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import java.sql.SQLException;
import java.util.List;

@Path("/pre-diagnostico")
public class PreDiagnosticoResource {

    private PreDiagnosticoBO preDiagnosticoBO;

    public PreDiagnosticoResource() throws ClassNotFoundException, SQLException {
        this.preDiagnosticoBO = new PreDiagnosticoBO();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response inserir(PreDiagnosticoVO preDiagnostico) {
        String resultado = preDiagnosticoBO.inserir(preDiagnostico);
        return Response.ok(resultado).build();
    }

    @DELETE
    @Path("/{id}")
    @Produces(MediaType.TEXT_PLAIN)
    public Response deletar(@PathParam("id") String idPreDiagnostico) {
        String resultado = preDiagnosticoBO.deletar(idPreDiagnostico);
        return Response.ok(resultado).build();
    }

    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response atualizar(PreDiagnosticoVO preDiagnostico) {
        String resultado = preDiagnosticoBO.atualizar(preDiagnostico);
        return Response.ok(resultado).build();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response selecionarTodos() {
        List<PreDiagnosticoVO> listaPreDiagnosticos = preDiagnosticoBO.selecionarTodos();
        if (listaPreDiagnosticos == null) {
            return Response.serverError().entity("Erro ao listar pré-diagnósticos.").build();
        }
        return Response.ok(listaPreDiagnosticos).build();
    }
}
