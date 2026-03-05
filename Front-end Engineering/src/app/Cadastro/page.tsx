'use client';
import { useRouter } from 'next/navigation';
import styles from "./Cadastro.module.css"; 
import { useEffect, useState } from 'react';
import InputMask from 'react-input-mask';
import CarroForm from './CarroForm';

const Cadastro = () => {
    const [nome, setNome] = useState('');
    const [sobrenome, setSobrenome] = useState('');
    const [dataNasc, setDataNasc] = useState('');
    const [telefone, setTelefone] = useState('');
    const [email, setEmail] = useState('');
    const [senha, setSenha] = useState('');
    const [confirmarSenha, setConfirmarSenha] = useState('');
    const [cpf, setCpf] = useState('');
    const [cnh, setCnh] = useState('');
    const [rg, setRg] = useState('');
    const [cep, setCep] = useState('');
    const [rua, setRua] = useState('');
    const [numeroResidencial, setNumeroResidencial] = useState('');
    const [complemento, setComplemento] = useState('');
    const [bairro, setBairro] = useState('');
    const [cidade, setCidade] = useState('');
    const [estado, setEstado] = useState('');
    const [carros, setCarros] = useState([{ placa: '', marca: '', modelo: '', ano: '' }]);
    const [mostrarSenha, setMostrarSenha] = useState(false);
    const [mostrarSenha2, setMostrarSenha2] = useState(false);

    useEffect(() => {
        document.title = "Cadastro - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
    }, [])

    const router = useRouter();

const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();

    if (senha !== confirmarSenha) {
        alert("As senhas não coincidem.");
        return;
    }

    const cliente = {
        cpfCliente: cpf,
        cnhCliente: cnh,
        rgCliente: rg,
        nomeCliente: nome,
        sobrenomeCliente: sobrenome,
        dataNascCliente: dataNasc,
        emailCliente: email,
        senhaCliente: senha,
        telefoneCliente: telefone,
        enderecoCliente: `${rua}, ${numeroResidencial}, ${complemento || 'N/A'}, ${bairro}, ${cidade}, ${estado}, ${cep}`
    };

    try {
        await createCliente(cliente);
        
        sessionStorage.setItem('cliente', JSON.stringify(cliente)); // Armazenar cliente no sessionStorage
        await cadastrarCarros(cpf); // Chamar a função para cadastrar carros

        sessionStorage.setItem('carros', JSON.stringify(carros)); // Armazenar os carros no sessionStorage após cadastro

        router.push('/Login'); // Redirecionar após o sucesso
    } catch (error) {
        console.error("Erro ao cadastrar cliente:", error);
        alert("Erro ao cadastrar cliente.");
    }
};

    const createCliente = async (cliente: { 
        cpfCliente: string; 
        cnhCliente: string; 
        rgCliente: string; 
        nomeCliente: string; 
        sobrenomeCliente: string; 
        dataNascCliente: string; 
        emailCliente: string; 
        senhaCliente: string; 
        telefoneCliente: string; 
        enderecoCliente: string; 
    }) => {
        try {
            const response = await fetch('http://localhost:8080/diagnoscarweb/rest/cliente', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(cliente),
            });

            const responseText = await response.text();

            if (!response.ok) {
                throw new Error(`Erro ao criar cliente: ${responseText}`);
            }

            console.log('Cliente cadastrado com sucesso:', responseText);
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

    const cadastrarCarros = async (cpfCliente: string) => {
        const carrosArray: never[] = [];
        for (const carro of carros) {
            const automovel = {
                placaAutomovel: carro.placa,
                marcaAutomovel: carro.marca,
                modeloAutomovel: carro.modelo,
                anoAutomovel: Number(carro.ano),
                clienteCpfCliente: cpfCliente
            };

            try {
                const response = await fetch('http://localhost:8080/diagnoscarweb/rest/automovel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(automovel),
                });

                const responseText = await response.text();

                if (!response.ok) {
                    throw new Error(`Erro ao cadastrar automóvel: ${responseText}`);
                }

                console.log('Automóvel cadastrado com sucesso:', responseText);
            } catch (error) {
                const errorMessage = error instanceof Error ? error.message : 'Ocorreu um erro desconhecido';
                console.error('Erro ao cadastrar automóvel:', error);
                alert(`Erro ao cadastrar automóvel: ${errorMessage}`);
            }
        }
        sessionStorage.setItem('carros', JSON.stringify(carrosArray));
    };


    const buscaCep = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const cepUSER = e.target.value.replace(/\D/g, '');
        setCep(cepUSER);

        if (cepUSER.length === 8) {
            try {
                const response = await fetch(`https://viacep.com.br/ws/${cepUSER}/json/`);
                const dadosCEP = await response.json();
                console.log(dadosCEP)

                if (!dadosCEP.erro) {
                    setRua(dadosCEP.logradouro);
                    setBairro(dadosCEP.bairro);
                    setCidade(dadosCEP.localidade);
                    setEstado(dadosCEP.uf);
                }
            } catch (error) {
                console.error("Erro ao buscar o CEP:", error);
            }
        }
    };

    const adicionarCarro = () => {
        setCarros((prevCarros) => [...prevCarros, { placa: '', marca: '', modelo: '', ano: '' }]);
    };

    const removerCarro = (index: number) => {
        if (carros.length > 1) {
            setCarros((prevCarros) => prevCarros.filter((_, i) => i !== index));
        }
    };

    const handleInputChange = (index: number, e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setCarros((prevCarros) =>
            prevCarros.map((carro, i) => i === index ? { ...carro, [name]: value } : carro)
        );
    };

    const VisibilidadeSenha = () => {
        setMostrarSenha(!mostrarSenha);
    };

    const VisibilidadeSenha2 = () => {
        setMostrarSenha2(!mostrarSenha2);
    };

    return (
        <>
            <section className={styles.forms}>
                <form onSubmit={handleRegister}>
                    <fieldset className={styles.fieldset}>
                        <legend className={styles.legenda}>Dados Pessoais</legend>

                        <label className={styles.label}> Nome: <br /> 
                            <input 
                                type="text" 
                                name="Nome" 
                                placeholder="Digite seu Nome" 
                                value={nome}
                                onChange={(e) => setNome(e.target.value)} 
                                required  
                                className={styles.inputField}
                            /> 
                        </label><br />

                        <label className={styles.label}> Sobrenome: <br /> 
                            <input 
                                type="text" 
                                name="Sobrenome" 
                                placeholder="Digite seu Sobrenome" 
                                value={sobrenome}
                                onChange={(e) => setSobrenome(e.target.value)} 
                                required  
                                className={styles.inputField}
                            /> 
                        </label><br />

                        <label className={styles.label}> Data de Nascimento: <br /> 
                            <input 
                                type="date" 
                                name="dataNascimento" 
                                min="1900-01-01" 
                                max="2006-12-31"
                                value={dataNasc}
                                onChange={(e) => setDataNasc(e.target.value)}  
                                required  
                                className={styles.inputField}
                            /> 
                        </label><br />

                        <label className={styles.label}> Telefone Celular: <br /> 
                            <InputMask
                                mask="(99) 99999-9999"
                                type="text"
                                name="telefone"
                                placeholder="Digite seu telefone"
                                value={telefone}
                                onChange={(e) => setTelefone(e.target.value)}
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}>E-mail: <br /> 
                            <input 
                                type="email" 
                                name="email"  
                                placeholder="Digite seu e-mail" 
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required  
                                className={styles.inputField}
                            /> 
                        </label><br/>

                        <label className={styles.label}>Senha: <br /> 
                            <div className={styles.passwordWrapper}>
                                <input 
                                    type={mostrarSenha ? 'text' : 'password'}
                                    name="senha" 
                                    placeholder="Digite uma senha"
                                    value={senha}
                                    onChange={(e) => setSenha(e.target.value)} 
                                    required  
                                    className={styles.inputField}
                                />
                                <button 
                                    type="button" 
                                    onClick={VisibilidadeSenha}
                                    className={styles.toggleButton}
                                >
                                    {mostrarSenha ? '👁️' : '🙈'}
                                </button>
                            </div>
                        </label><br/>
                        
                        <label className={styles.label}>Confirmar Senha: <br /> 
                            <div className={styles.passwordWrapper}>
                                <input 
                                    type={mostrarSenha2 ? 'text' : 'password'}
                                    name="confirmarSenha" 
                                    placeholder="Confirme sua senha"
                                    value={confirmarSenha}
                                    onChange={(e) => setConfirmarSenha(e.target.value)} 
                                    required  
                                    className={styles.inputField}
                                />
                                <button 
                                    type="button" 
                                    onClick={VisibilidadeSenha2}
                                    className={styles.toggleButton}
                                >
                                    {mostrarSenha2 ? '👁️' : '🙈'}
                                </button>
                            </div>
                        </label><br />
                    </fieldset>

                    <fieldset className={styles.fieldset}>
                        <legend className={styles.legenda}>Documentos</legend>

                        <label className={styles.label}> CPF: <br /> 
                            <InputMask
                                mask="999.999.999-99"
                                type="text"
                                name="cpf"
                                placeholder="Digite seu CPF"
                                value={cpf}
                                onChange={(e) => setCpf(e.target.value)}
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> CNH: <br /> 
                            <InputMask
                                mask="99999999999"
                                type="text"
                                name="cnh"
                                placeholder="Digite sua CNH"
                                value={cnh}
                                onChange={(e) => setCnh(e.target.value)}
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> RG: <br /> 
                            <InputMask
                                mask="99.999.999-9"
                                type="text"
                                name="rg"
                                placeholder="Digite seu RG"
                                value={rg}
                                onChange={(e) => setRg(e.target.value)}
                                required  
                                className={styles.inputField}
                            />
                        </label><br />
                    </fieldset>

                    <fieldset className={styles.fieldset}>
                        <legend className={styles.legenda}>Endereço</legend>

                        <label className={styles.label}> CEP: <br /> 
                            <InputMask
                                mask="99999-999"
                                type="text"
                                name="cep"
                                placeholder="Digite seu CEP"
                                value={cep}
                                onChange={buscaCep}
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> Rua: <br /> 
                            <input 
                                type="text" 
                                name="rua" 
                                placeholder="Digite sua Rua" 
                                value={rua}
                                onChange={(e) => setRua(e.target.value)} 
                                required  
                                className={styles.inputField}
                            /> 
                        </label><br />

                        <label className={styles.label}> Número Residencial: <br /> 
                            <input 
                                type="text" 
                                name="numero" 
                                placeholder="Digite o Número"
                                value={numeroResidencial}
                                onChange={(e) => setNumeroResidencial(e.target.value)} 
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> Complemento: <br /> 
                            <input 
                                type="text" 
                                name="complemento" 
                                placeholder="Opcional" 
                                value={complemento}
                                onChange={(e) => setComplemento(e.target.value)} 
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> Bairro: <br /> 
                            <input 
                                type="text" 
                                name="bairro" 
                                placeholder="Digite seu Bairro" 
                                value={bairro}
                                onChange={(e) => setBairro(e.target.value)} 
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> Cidade: <br /> 
                            <input 
                                type="text" 
                                name="cidade" 
                                placeholder="Digite sua Cidade" 
                                value={cidade}
                                onChange={(e) => setCidade(e.target.value)} 
                                required  
                                className={styles.inputField}
                            />
                        </label><br />

                        <label className={styles.label}> Estado: <br /> 
                            <input 
                                type="text" 
                                name="estado" 
                                placeholder="Digite seu Estado" 
                                value={estado}
                                onChange={(e) => setEstado(e.target.value)} 
                                required  
                                className={styles.inputField}
                            />
                        </label><br />
                    </fieldset>

                    <fieldset className={styles.fieldset}>
                        <legend className={styles.legenda}>Dados do Automóvel</legend>
                        {carros.map((carro, index) => (
                            <CarroForm 
                                key={index}
                                index={index}
                                carro={carro}
                                handleInputChange={handleInputChange}
                                removerCarro={removerCarro} carros={[]}                            />
                        ))}
                        <button 
                            type="button" 
                            onClick={adicionarCarro} 
                            className={styles.botaoAdicionar}
                        >
                            Adicionar Carro
                        </button>
                    </fieldset>

                    <button type="submit" className={styles.botao}>
                        Cadastrar
                    </button>
                </form>
            </section>
        </>
    );
};

export default Cadastro;
