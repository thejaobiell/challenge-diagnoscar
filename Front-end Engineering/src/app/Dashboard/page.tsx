'use client';
import { useRouter } from 'next/navigation';
import styles from './Dashboard.module.css';
import { useEffect, useState } from 'react';
import InputMask from 'react-input-mask';

interface Carro {
  placa: string;
  marca: string;
  modelo: string;
  ano: string;
}

interface Endereco {
  rua: string;
  numeroResidencial: string;
  complemento: string;
  bairro: string;
  cidade: string;
  estado: string;
  cep: string;
}

interface UserData {
  nomeCliente: string;
  sobrenomeCliente: string;
  dataNascCliente: string;
  telefoneCliente: string;
  emailCliente: string;
  cpfCliente: string;
  cnhCliente: string;
  rgCliente: string;
  senhaCliente: string; 
  enderecoCliente: Endereco; 
}

const Dashboard = () => {
  const [carros, setCarros] = useState<Carro[]>([]);
  const [userData, setUserData] = useState<UserData | null>(null);
  const [estaEditando, setEstaEditando] = useState(false);
  const [senhaAtual, setSenhaAtual] = useState('');
  const [novaSenha, setNovaSenha] = useState('');
  const [confirmarNovaSenha, setConfirmarNovaSenha] = useState('');
  const router = useRouter();

  useEffect(() => {
    document.title = "Dashboard - DiagnosCAR";
    const link = document.createElement('link');
    link.rel = 'icon';
    link.href = '/img/Logos/Diagnoscar.ico';
    document.head.appendChild(link);
  }, []);

  useEffect(() => {
    const logado = sessionStorage.getItem('logado');
    if (logado !== 'sim') {
      router.push('/Login');
    }

    const clienteData = sessionStorage.getItem('cliente');
    const carrosData = sessionStorage.getItem('carros');

    if (clienteData && carrosData) {
      const cliente = JSON.parse(clienteData);
      const carrosArray = JSON.parse(carrosData);
      
      setUserData({
        nomeCliente: cliente.nomeCliente,
        sobrenomeCliente: cliente.sobrenomeCliente,
        dataNascCliente: cliente.dataNascCliente,
        telefoneCliente: cliente.telefoneCliente,
        emailCliente: cliente.emailCliente,
        cpfCliente: cliente.cpfCliente,
        cnhCliente: cliente.cnhCliente,
        rgCliente: cliente.rgCliente,
        senhaCliente: cliente.senhaCliente,
        enderecoCliente: {
          rua: cliente.enderecoCliente.split(', ')[0],
          numeroResidencial: cliente.enderecoCliente.split(', ')[1],
          complemento: cliente.enderecoCliente.split(', ')[2],
          bairro: cliente.enderecoCliente.split(', ')[3],
          cidade: cliente.enderecoCliente.split(', ')[4],
          estado: cliente.enderecoCliente.split(', ')[5],
          cep: cliente.enderecoCliente.split(', ')[6],
        },
      });

      setCarros(carrosArray);
    }
  }, [router]);

  const ClickImagem = (carro: Carro) => {
    return () => {
      localStorage.setItem('carroSelecionado', JSON.stringify(carro));
      router.push('/Pre-Diagnostico');
    };
  };

  const logout = () => {
    sessionStorage.removeItem('logado');
    localStorage.removeItem('carroSelecionado');
    router.push('/Login');
  };

  const bloquearEdicao = (e: React.FocusEvent<HTMLInputElement | HTMLSelectElement>) => {
    const campoEditavel = e.target.name === 'email' || e.target.name === 'senha';
    if (!campoEditavel) {
      alert("Este campo não pode ser editado. Por favor, entre em contato com o suporte.");
      e.target.blur();
    }
  };

  const salvarEdicao = () => {
    if (senhaAtual !== userData?.senhaCliente) {
      alert('Senha atual incorreta. Por favor, insira a senha correta para confirmar as alterações.');
      return;
    }

    if (novaSenha && confirmarNovaSenha) {
      if (novaSenha !== confirmarNovaSenha) {
        alert('As novas senhas não coincidem. Tente novamente.');
        return;
      }
    }

    if (userData) {
      const senhaAtualizada = novaSenha && confirmarNovaSenha ? novaSenha : userData.senhaCliente;

      // Mantendo a estrutura original ao salvar no sessionStorage
      const clienteParaSalvar = {
        cpfCliente: userData.cpfCliente,
        cnhCliente: userData.cnhCliente,
        rgCliente: userData.rgCliente,
        nomeCliente: userData.nomeCliente,
        sobrenomeCliente: userData.sobrenomeCliente,
        dataNascCliente: userData.dataNascCliente,
        emailCliente: userData.emailCliente,
        senhaCliente: senhaAtualizada,
        telefoneCliente: userData.telefoneCliente,
        enderecoCliente: `${userData.enderecoCliente.rua}, ${userData.enderecoCliente.numeroResidencial}, ${userData.enderecoCliente.complemento}, ${userData.enderecoCliente.bairro}, ${userData.enderecoCliente.cidade}, ${userData.enderecoCliente.estado}, ${userData.enderecoCliente.cep}`
      };

      sessionStorage.setItem('cliente', JSON.stringify(clienteParaSalvar));

      alert('Informações salvas com sucesso!');
      setEstaEditando(false);
      setSenhaAtual('');
      setNovaSenha('');
      setConfirmarNovaSenha('');
    }
  };

  const lidarEdicao = () => {
    setEstaEditando(true);
  };

  const cancelarEdicao = () => {
    setEstaEditando(false);
    const dataUserArmazenados = sessionStorage.getItem('cliente');
    if (dataUserArmazenados) {
      const data = JSON.parse(dataUserArmazenados);
      setUserData(data);
      setSenhaAtual('');
      setNovaSenha('');
      setConfirmarNovaSenha('');
    }
  };

  return (
    <>
      <section className={styles.container}>
        <fieldset className={`${styles.fieldset} ${styles.info_usuario}`}>
          <legend><h1>Informações do Usuário:</h1></legend>
          <div className={styles.info}>
            {estaEditando ? (
              userData && (
                <>
                  <label>Nome: <br/>
                    <input
                      type="text"
                      name="nome"
                      value={userData.nomeCliente || ''}
                      readOnly
                      onFocus={bloquearEdicao}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Sobrenome: <br/>
                    <input
                      type="text"
                      name="sobrenome"
                      value={userData.sobrenomeCliente || ''}
                      readOnly
                      onFocus={bloquearEdicao}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Data de Nascimento: <br/>
                    <input
                      type="date"
                      name="dataNasc"
                      value={userData.dataNascCliente || ''}
                      readOnly
                      onFocus={bloquearEdicao}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Telefone: <br/>
                    <InputMask
                      mask="(99) 99999-9999"
                      type="text"
                      name="telefone"
                      value={userData.telefoneCliente || ''}
                      readOnly
                      onFocus={bloquearEdicao}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Email: <br/>
                    <input
                      type="email"
                      name="email"
                      value={userData.emailCliente || ''}
                      onChange={(e) => setUserData({ ...userData!, emailCliente: e.target.value })}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Senha Atual: <br />
                    <input 
                      type="password"
                      name="senhaAtual"
                      value={senhaAtual}
                      onChange={(e) => setSenhaAtual(e.target.value)}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Nova Senha: <br />
                    <input 
                      type="password"
                      name="novaSenha"
                      value={novaSenha}
                      onChange={(e) => setNovaSenha(e.target.value)}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <label>Confirmar Nova Senha: <br />
                    <input 
                      type="password"
                      name="confirmarNovaSenha"
                      value={confirmarNovaSenha}
                      onChange={(e) => setConfirmarNovaSenha(e.target.value)}
                      className={styles.inputField}
                    />
                  </label><br/>

                  <button onClick={salvarEdicao} className={styles.botao}>
                    Salvar
                  </button>

                  <button onClick={cancelarEdicao} className={styles.cancelButton}>
                    Cancelar
                  </button>
                </>
              )
            ) : (
            userData && (
              <>
                <p>Nome: {userData.nomeCliente}</p>
                <p>Sobrenome: {userData.sobrenomeCliente}</p>
                <p>Data de Nascimento: {userData.dataNascCliente}</p>
                <p>Telefone: {userData.telefoneCliente}</p>
                <p>Email: {userData.emailCliente}</p>
                <p>CPF: {userData.cpfCliente}</p>
                <p>CNH: {userData.cnhCliente}</p>
                <p>RG: {userData.rgCliente}</p>
                <p>Endereço: {userData.enderecoCliente.rua}, {userData.enderecoCliente.numeroResidencial}, {userData.enderecoCliente.complemento}, {userData.enderecoCliente.bairro}, {userData.enderecoCliente.cidade}, {userData.enderecoCliente.estado}, {userData.enderecoCliente.cep}</p>
                <button onClick={lidarEdicao} className={styles.botao}>
                  Editar
                </button>
              </>
            )
            )}
          </div>
        </fieldset>

        <section className={styles.selecao_carro}>
          <fieldset className={styles.fieldset}>
            <legend> <h1>Selecione um carro da lista abaixo:</h1> </legend>
            <div className={styles.lista}>
              {carros.length > 0 ? (
                carros.map((carro, index) => (
                  <article key={index} className={styles.item}>
                    <img
                      src="/img/carro/CarroGenerico.png"
                      alt="Imagem genérica de Carro"
                      className={styles.img}
                      onClick={ClickImagem(carro)}
                    />
                    <div className={styles.info}>
                      <p>Marca: {carro.marca}</p>
                      <p>Modelo: {carro.modelo}</p>
                      <p>Ano: {carro.ano}</p>
                      <p>Placa: {carro.placa}</p>
                    </div>
                  </article>
                ))
              ) : (
                <p>Nenhum carro cadastrado</p>
              )}
            </div>
          </fieldset>
        </section>
      </section>

      <button onClick={logout} className={styles.logoutButton}>
        Logout
      </button>
    </>
  );
};

export default Dashboard;
