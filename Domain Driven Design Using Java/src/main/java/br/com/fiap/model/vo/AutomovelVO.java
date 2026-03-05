package br.com.fiap.model.vo;

public class AutomovelVO {
    private String placaAutomovel;    
    private String marcaAutomovel;    
    private String modeloAutomovel;       
    private int anoAutomovel;          
    private String clienteCpfCliente;  
    
    public AutomovelVO() {}
    
    public AutomovelVO(String placaAutomovel, String marcaAutomovel, String modeloAutomovel, int anoAutomovel, String clienteCpfCliente) {
        this.placaAutomovel = placaAutomovel;
        this.marcaAutomovel = marcaAutomovel;
        this.modeloAutomovel = modeloAutomovel;
        this.anoAutomovel = anoAutomovel;
        this.clienteCpfCliente = clienteCpfCliente;
    }

    public String getPlacaAutomovel() {
        return placaAutomovel;
    }

    public void setPlacaAutomovel(String placaAutomovel) {
        this.placaAutomovel = placaAutomovel;
    }

    public String getMarcaAutomovel() {
        return marcaAutomovel;
    }

    public void setMarcaAutomovel(String marcaAutomovel) {
        this.marcaAutomovel = marcaAutomovel;
    }

    public String getModeloAutomovel() {
        return modeloAutomovel;
    }

    public void setModeloAutomovel(String modeloAutomovel) {
        this.modeloAutomovel = modeloAutomovel;
    }

    public int getAnoAutomovel() {
        return anoAutomovel;
    }

    public void setAnoAutomovel(int anoAutomovel) {
        this.anoAutomovel = anoAutomovel;
    }

    public String getClienteCpfCliente() {
        return clienteCpfCliente;
    }

    public void setClienteCpfCliente(String clienteCpfCliente) {
        this.clienteCpfCliente = clienteCpfCliente;
    }
}
