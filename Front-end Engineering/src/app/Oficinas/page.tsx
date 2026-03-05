'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import styles from './Oficinas.module.css';

interface Oficina {
    Endereco_Oficina: string;
    Cnpj_Oficina: string;
    Nome_Oficina: string;
    Avaliacao_Oficina: number;
    Especializacao_Oficina: string;
}

const Oficinas = () => {
    const router = useRouter();
    const [oficinaSelecionada, setOficinaSelecionada] = useState<number | null>(null);
    const [dataVisita, setDataVisita] = useState<string>('');
    const [horaVisita, setHoraVisita] = useState<string>('');

    useEffect(() => {
        const logado = sessionStorage.getItem('logado');
        if (logado !== 'sim') {
            router.push('/Login');
        }
    }, [router]);

    useEffect(() => {
        document.title = "Oficinas Recomendadas - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
    }, []);

    const oficinas: Oficina[] = [
        {
            Endereco_Oficina: "Rua do Oratório, 630, Mooca, 03116-000 - São Paulo - SP",
            Cnpj_Oficina: "37.139.429/0001-74",
            Nome_Oficina: "BASTOS CAR FUNILARIA E PINTURA",
            Avaliacao_Oficina: 8.5,
            Especializacao_Oficina: "Funilaria e pintura",
        },
        {
            Endereco_Oficina: "Rua CLIMACO BARBOSA, 191, CAMBUCI, 01523-000 - SAO PAULO - SP",
            Cnpj_Oficina: "10.437.521/0001-64",
            Nome_Oficina: "CLUBCAR VEICULOS CAMBUCI",
            Avaliacao_Oficina: 8.7,
            Especializacao_Oficina: "Elétrica",
        },
    ];

    const horariosDisponiveis = [
        '09:00', '09:30', '10:00', '10:30', '11:00', 
        '11:30', '12:00', '12:30', '13:00', '14:00', 
        '14:30', '15:00', '15:30', '16:00', '16:30', 
        '17:00', '17:30', '18:00', '18:30',
    ];

    useEffect(() => {
        const storedData = sessionStorage.getItem('agendamento');
        if (storedData) {
            const { oficinaSelecionada, dataVisita, horaVisita } = JSON.parse(storedData);
            setOficinaSelecionada(oficinaSelecionada);
            setDataVisita(dataVisita);
            setHoraVisita(horaVisita);
        }
    }, []);

    const handleSelect = (index: number) => {
        setOficinaSelecionada(index);
        setDataVisita('');
        setHoraVisita('');
    };

    const handleConfirmar = () => {
        if (oficinaSelecionada === null) return;

        if (!dataVisita || !horaVisita) {
            alert('Por favor, preencha todos os campos de agendamento.');
            return;
        }

        const dataAtual = new Date();
        const [ano, mes, dia] = dataVisita.split('-').map(Number);
        const [hora, minuto] = horaVisita.split(':').map(Number);

        const dataSelecionada = new Date(ano, mes - 1, dia, hora, minuto);

        if (ano < 2024 || ano > 2025) {
            alert('A data deve ser entre os anos de 2024 e 2025.');
            return;
        }

        if (dataSelecionada < dataAtual) {
            alert('A data e hora selecionadas não podem estar no passado.');
            return;
        }

        if (dataSelecionada.toDateString() === dataAtual.toDateString() && dataSelecionada.getTime() <= dataAtual.getTime()) {
            alert('A data e hora selecionadas não podem estar no passado.');
            return;
        }

        const oficinaSelecionadaData = oficinas[oficinaSelecionada];
        alert(`Visita agendada com ${oficinaSelecionadaData.Nome_Oficina} em ${dataVisita} às ${horaVisita}`);

        sessionStorage.setItem('agendamento', JSON.stringify({
            oficinaSelecionada,
            dataVisita,
            horaVisita,
            oficina: oficinaSelecionadaData,
        }));

        router.push('/ObrigadoPorUsar');
    };

    const today = new Date();
    const minDate = today.toISOString().split('T')[0];
    const maxDate = '2025-12-31';

    return (
        <div className={styles.container}>
            <h1 className={styles.title}>Oficinas por Perto</h1>
            <table className={styles.table}>
                <thead className={styles.thead}>
                    <tr className={styles.tr}>
                        <th className={styles.th}>Selecionar</th>
                        <th className={styles.th}>Endereço</th>
                        <th className={styles.th}>CNPJ</th>
                        <th className={styles.th}>Nome</th>
                        <th className={styles.th}>Especialização</th>
                        <th className={styles.th}>Avaliação</th>
                    </tr>
                </thead>
                <tbody className={styles.tbody}>
                    {oficinas.map((oficina, index) => (
                        <tr key={index} className={styles.tr}>
                            <td className={styles.td}>
                                <input
                                    type="radio"
                                    name="oficina"
                                    checked={oficinaSelecionada === index}
                                    onChange={() => handleSelect(index)}
                                />
                            </td>
                            <td className={styles.td}>{oficina.Endereco_Oficina}</td>
                            <td className={styles.td}>{oficina.Cnpj_Oficina}</td>
                            <td className={styles.td}>{oficina.Nome_Oficina}</td>
                            <td className={styles.td}>{oficina.Especializacao_Oficina}</td>
                            <td className={styles.td}>{oficina.Avaliacao_Oficina}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
            {oficinaSelecionada !== null && (
                <div className={styles.selectedOficina}>
                    <h2>Oficina Selecionada</h2>
                    <div className={styles.agendarContainer}>
                        <div>
                            <p><strong>Nome:</strong> {oficinas[oficinaSelecionada].Nome_Oficina}</p>
                            <p><strong>Endereço:</strong> {oficinas[oficinaSelecionada].Endereco_Oficina}</p>
                            <p><strong>CNPJ:</strong> {oficinas[oficinaSelecionada].Cnpj_Oficina}</p>
                            <p><strong>Especialização:</strong> {oficinas[oficinaSelecionada].Especializacao_Oficina}</p>
                            <p><strong>Avaliação:</strong> {oficinas[oficinaSelecionada].Avaliacao_Oficina}</p>
                        </div>

                        <fieldset className={`${styles.fieldset} ${styles.agendarVisita}`}>
                            <legend>Agendar Visita</legend>
                            <div>
                                <label htmlFor="dataVisita">Data:</label>
                                <input
                                    type="date"
                                    id="dataVisita"
                                    value={dataVisita}
                                    min={minDate}
                                    max={maxDate}
                                    onChange={(e) => setDataVisita(e.target.value)}
                                    required
                                />
                            </div>
                            <div>
                                <label htmlFor="horaVisita">Hora:</label>
                                <select
                                    id="horaVisita"
                                    value={horaVisita}
                                    onChange={(e) => setHoraVisita(e.target.value)}
                                    required
                                >
                                    <option value="" disabled>Selecione um horário</option>
                                    {horariosDisponiveis.map((horario, index) => (
                                        <option key={index} value={horario}>{horario}</option>
                                    ))}
                                </select>
                            </div>
                            <button onClick={handleConfirmar} className={styles.botao}>
                                Confirmar Agendamento
                            </button>
                        </fieldset>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Oficinas;
