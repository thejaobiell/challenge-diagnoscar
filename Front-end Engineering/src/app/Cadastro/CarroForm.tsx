import React, { useState } from 'react';
import InputMask from 'react-input-mask';
import styles from "./Cadastro.module.css";

interface CarroFormProps {
    index: number;
    carro: {
        placa: string;
        marca: string;
        modelo: string;
        ano: string;
    };
    handleInputChange: (index: number, e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => void;
    removerCarro: (index: number) => void;
    carros: { placa: string; marca: string; modelo: string; ano: string }[];
}

const CarroForm: React.FC<CarroFormProps> = ({ index, carro, handleInputChange, removerCarro }) => {
    const [placaTipo, setPlacaTipo] = useState<'mercosul' | 'brasileira'>('brasileira');

    const handleUppercaseInput = (e: React.ChangeEvent<HTMLInputElement>) => {
        e.target.value = e.target.value.toUpperCase();
        handleInputChange(index, e);
    };

    const handlePlacaTipoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setPlacaTipo(e.target.value as 'mercosul' | 'brasileira');
    };

    const handleAnoInput = (e: React.FormEvent<HTMLInputElement>) => {
        const target = e.target as HTMLInputElement;
        const input = target.value.replace(/[^0-9]/g, '');
        target.value = input.slice(0, 4);
    };

    return (
        <fieldset className={styles.formGroup}>
            <legend className={styles.legenda}>Carro {index + 1}</legend>

            <label className={styles.label}>
                Tipo de Placa: <br />
                <input
                    type="radio"
                    name={`placaTipo-${index}`}
                    value="brasileira"
                    checked={placaTipo === 'brasileira'}
                    onChange={handlePlacaTipoChange}
                /> Brasileira
                <input
                    type="radio"
                    name={`placaTipo-${index}`}
                    value="mercosul"
                    checked={placaTipo === 'mercosul'}
                    onChange={handlePlacaTipoChange}
                /> Mercosul
            </label> <br/>

            <label className={styles.label}>
                Placa: <br />
                <InputMask
                    type="text"
                    name="placa"
                    value={carro.placa}
                    onChange={handleUppercaseInput}
                    mask={placaTipo === 'mercosul' ? 'aaa9a99' : 'aaa9999'}
                    placeholder="Digite sua placa"
                    required
                    className={styles.inputField}
                />
            </label> <br/>

            <label className={styles.label}>
                Marca: <br />
                <select
                    name="marca"
                    value={carro.marca}
                    onChange={(e) => handleInputChange(index, e)}
                    required
                    className={styles.inputField}
                >
                    <option value="" disabled>Selecione a marca</option>
                    <option value="Audi">Audi</option>
                    <option value="BMW">BMW</option>
                    <option value="CAOA Cherry">CAOA Cherry</option>
                    <option value="Chevrolet">Chevrolet</option>
                    <option value="Citroën">Citroën</option>
                    <option value="Ferrari">Ferrari</option>
                    <option value="Fiat">Fiat</option>
                    <option value="Ford">Ford</option>
                    <option value="Honda">Honda</option>
                    <option value="Hyundai">Hyundai</option>
                    <option value="Jaguar">Jaguar</option>
                    <option value="JAC">JAC</option>
                    <option value="Jeep">Jeep</option>
                    <option value="Kia">Kia</option>
                    <option value="Lamborghini">Lamborghini</option>
                    <option value="Land Rover">Land Rover</option>
                    <option value="Mitsubishi">Mitsubishi</option>
                    <option value="Nissan">Nissan</option>
                    <option value="Peugeot">Peugeot</option>
                    <option value="Renault">Renault</option>
                    <option value="Subaru">Subaru</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Volkswagen">Volkswagen</option>
                    <option value="Volvo">Volvo</option>
                </select>
            </label> <br/>

            <label className={styles.label}>
                Modelo: <br />
                <input
                    type="text"
                    name="modelo"
                    value={carro.modelo}
                    onChange={(e) => handleInputChange(index, e)}
                    placeholder="Digite o modelo"
                    required
                    className={styles.inputField}
                />
            </label> <br/>

            <label className={styles.label}>
                Ano: <br />
                <input
                    type="text"
                    name="ano"
                    value={carro.ano}
                    onInput={handleAnoInput}
                    onChange={(e) => handleInputChange(index, e)}
                    placeholder="Digite o ano"
                    required
                    className={styles.inputField}
                />
            </label> <br/>

            <button type="button" onClick={() => removerCarro(index)} className={styles.botaoRemover}>Remover Carro</button>
        </fieldset>
    );
};

export default CarroForm;
