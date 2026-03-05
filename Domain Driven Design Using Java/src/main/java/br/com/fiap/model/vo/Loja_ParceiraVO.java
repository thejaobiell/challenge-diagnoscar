package br.com.fiap.model.vo;

public class Loja_ParceiraVO {
    private String enderecoLoja;
    private String cnpjLoja;
    private String nomeLoja;
    private Double avaliacaoLoja;
    private String especializacaoLoja;

    public Loja_ParceiraVO() {}
    
    public Loja_ParceiraVO(String enderecoLoja, String cnpjLoja, String nomeLoja, Double avaliacaoLoja, String especializacaoLoja) {
        this.enderecoLoja = enderecoLoja;
        this.cnpjLoja = cnpjLoja;
        this.nomeLoja = nomeLoja;
        this.avaliacaoLoja = avaliacaoLoja;
        this.especializacaoLoja = especializacaoLoja;
    }

    public String getEnderecoLoja() {
        return enderecoLoja;
    }

    public void setEnderecoLoja(String enderecoLoja) {
        this.enderecoLoja = enderecoLoja;
    }

    public String getCnpjLoja() {
        return cnpjLoja;
    }

    public void setCnpjLoja(String cnpjLoja) {
        this.cnpjLoja = cnpjLoja;
    }

    public String getNomeLoja() {
        return nomeLoja;
    }

    public void setNomeLoja(String nomeLoja) {
        this.nomeLoja = nomeLoja;
    }

    public Double getAvaliacaoLoja() {
        return avaliacaoLoja;
    }

    public void setAvaliacaoLoja(Double avaliacaoLoja) {
        this.avaliacaoLoja = avaliacaoLoja;
    }

    public String getEspecializacaoLoja() {
        return especializacaoLoja;
    }

    public void setEspecializacaoLoja(String especializacaoLoja) {
        this.especializacaoLoja = especializacaoLoja;
    }
}
