'use client';
import React, { useEffect, useState } from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';
import styles from './Guincho.module.css';
import Link from 'next/link';

const iconePadrao = L.icon({
  iconRetinaUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png',
  iconUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

const Guincho: React.FC = () => {
  useEffect(() => {
    document.title = "Chamando Guincho - DiagnosCAR";
    const link = document.createElement('link');
    link.rel = 'icon';
    link.href = '/img/Logos/Diagnoscar.ico';
    document.head.appendChild(link);
  }, []);

  const [localizacao, setLocalizacao] = useState<{ latitude: number | null; longitude: number | null }>({
    latitude: null,
    longitude: null,
  });

  const [endereco, setEndereco] = useState<string | null>(null);
  const [erro, setErro] = useState<string | null>(null);
  const [localizacaoObtida, setLocalizacaoObtida] = useState<boolean>(false); 

  const obterLocalizacao = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const latitude = position.coords.latitude;
          const longitude = position.coords.longitude;

          setLocalizacao({ latitude, longitude });
          setErro(null);
          setLocalizacaoObtida(true); 

          fetch(`https://nominatim.openstreetmap.org/reverse?lat=${latitude}&lon=${longitude}&format=json`)
            .then(response => response.json())
            .then(data => {
              const { road, suburb, city, state, postcode } = data.address;

              if (road) {
                const enderecoCompleto = `${road}, ${suburb || ''}, ${city || ''}, ${state || ''}, ${postcode || ''}`;
                setEndereco(enderecoCompleto);

                sessionStorage.setItem('localizacao', JSON.stringify({
                  rua: road,
                  bairro: suburb || '',
                  cidade: city || '',
                  estado: state || '',
                  cep: postcode || '',
                  latitude: latitude,
                  longitude: longitude
                }));
              } else if (postcode) {
                fetch(`https://viacep.com.br/ws/${postcode}/json/`)
                  .then(response => response.json())
                  .then(dataViaCEP => {
                    if (!dataViaCEP.erro) {
                      const { logradouro, bairro, localidade, uf } = dataViaCEP;
                      const enderecoCompleto = `${logradouro || ''}, ${bairro || ''}, ${localidade || ''}, ${uf || ''}, ${postcode}`;
                      setEndereco(enderecoCompleto);

                      sessionStorage.setItem('localizacao', JSON.stringify({
                        rua: logradouro || '',
                        bairro: bairro || '',
                        cidade: localidade || '',
                        estado: uf || '',
                        cep: postcode,
                        latitude: latitude,
                        longitude: longitude
                      }));
                    } else {
                      setErro('Endereço não encontrado.');
                      setEndereco(`Localização: [${latitude}, ${longitude}] - Cidade: ${city || 'Desconhecida'}, Estado: ${state || 'Desconhecido'}`);
                    }
                  })
                  .catch(() => setErro('Erro ao obter endereço pelo ViaCEP.'));
              } else {
                setEndereco(`Localização: [${latitude}, ${longitude}] - Cidade: ${city || 'Desconhecida'}, Estado: ${state || 'Desconhecido'}`);
              }
            })
            .catch(() => setErro('Erro ao obter endereço. Tente novamente.'));
        },
        (error) => {
          setErro('Erro ao obter localização, tente novamente.\n' + error.message);
        }
      );
    } else {
      setErro('Geolocalização não é suportada pelo navegador.');
    }
  };

  return (
    <div className={styles.container}>
      <h1>Sua atual localização: </h1>
      {!localizacaoObtida && (
        <button onClick={obterLocalizacao} className={styles.buttons}>Obter Localização</button>
      )}

      {erro && <p className={styles.error}>{erro}</p>}

      {localizacao.latitude && localizacao.longitude ? (
        <div>
          <MapContainer
            center={[localizacao.latitude, localizacao.longitude]}
            zoom={16}
            className={styles['leaflet-container']}
          >
            <TileLayer
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            />
            <Marker 
              position={[localizacao.latitude, localizacao.longitude]}
              icon={iconePadrao}
            >
              <Popup>
                Você está aqui:<br />
                Latitude: {localizacao.latitude}<br />
                Longitude: {localizacao.longitude}
              </Popup>
            </Marker>
          </MapContainer>

          {endereco ? (
            <h3 className={styles.endereco}>Endereço: {endereco}</h3>
          ) : (
            <p>Carregando endereço...</p>
          )}

          <p className={styles.coordenadas}>
            Coordenadas: [{localizacao.latitude}, {localizacao.longitude}]
          </p>

          <div className={styles['buttons-container']}>
            <h1>Enviar Guincho?</h1>
            <Link href="/ObrigadoPorUsar">
              <button className={styles.buttons}>Enviar</button>
            </Link>
            <Link href="/Pre-Diagnostico">
              <button className={styles.buttons}>Cancelar</button>
            </Link>
          </div>
        </div>
      ) : (
        <p>Localização ainda não obtida</p>
      )}
    </div>
  );
};

export default Guincho;
