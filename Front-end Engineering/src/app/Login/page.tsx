'use client';

import { useEffect, useState } from 'react';
import styles from './Login.module.css';
import Link from 'next/link';
import { useRouter } from 'next/navigation'; 

const Login = () => {
    const [email, setEmail] = useState('');
    const [senha, setSenha] = useState('');
    const [error, setError] = useState('');
    const [MostrarSenha, setMostrarSenha] = useState(false);
    const router = useRouter(); 

    useEffect(() => {
        document.title = "Login - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
        return () => {
            document.head.removeChild(link);
        };
    }, []);

    useEffect(() => {
        const logado = sessionStorage.getItem('logado');
        if (logado === 'sim') {
            router.push('/Dashboard');
        }
    }, [router]);

    const handleLogin = (e: React.FormEvent) => {
        e.preventDefault(); 

        const cliente = sessionStorage.getItem('cliente');
        if (cliente) {
            const clienteData = JSON.parse(cliente);

            if (clienteData.emailCliente === email && clienteData.senhaCliente === senha) {
                sessionStorage.setItem('logado', 'sim');
                router.push('/Dashboard');
            } else {
                setError('Email ou senha incorretos');
            }
        } else {
            setError('Usuário não encontrado. Faça o cadastro primeiro.'); 
        }
    }

    const mudarVisibilidadeSenha = () => {
        setMostrarSenha(!MostrarSenha);
    };

    return (
        <section className={styles.section}>
            <form id={styles.LOGIN} onSubmit={handleLogin}>
                <fieldset className={styles.fieldset}>
                    <legend><h1>LOGIN</h1></legend>
                    
                    <label htmlFor="txtEmail">
                        <h1>Email:</h1>
                        <input 
                            type="email" 
                            name="txtEmail" 
                            placeholder="Digite seu email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)} 
                            required 
                        />
                    </label>
                    <br />

                    <div>
                        <h1>Senha:</h1>
                        <div className={styles.passwordContainer}>
                            <input 
                                className={styles.input} 
                                type={MostrarSenha ? 'text' : 'password'} 
                                placeholder='Digite sua senha' 
                                value={senha} 
                                onChange={(e) => setSenha(e.target.value)} 
                                required
                            />
                            <button 
                                type="button" 
                                onClick={mudarVisibilidadeSenha} 
                                className={styles.toggleButton}
                            >
                                {MostrarSenha ? '👁️' : '🙈'}
                            </button>
                        </div>
                    </div>

                    <br/>

                    {error && <p style={{ color: 'red' }}>{error}</p>} 

                    <Link href="/Cadastro" className={styles.criar}>
                        <h1>Criar um cadastro</h1>
                    </Link>
                    <button type="submit" className={styles.button}>Entrar</button>
                </fieldset>
            </form>
        </section>
    );
};

export default Login;
