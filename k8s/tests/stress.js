import http from 'k6/http';
import { check, sleep } from 'k6';

const urlServico = __ENV.URL_SERVICO || "http://localhost:8080";

export let options = {
    stages: [
        { duration: '10s', target: 100 }, // Sobe para 100 usuários em 10s
        { duration: '1m', target: 100 },  // Mantém 100 usuários por 1min
        { duration: '10s', target: 0 },  // Reduz para 0 usuários em 10s
    ],
};

export default function () {
    let res = http.get(`${urlServico}/api/CategoriaControllerHandler/ListarTodosCategoria`);
    check(res, {
        'status is 200': (r) => r.status === 200,
    });
    sleep(1);
}