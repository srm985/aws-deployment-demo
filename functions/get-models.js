import {
    createPool
} from 'mysql2/promise';

const pool = createPool({
    database: process.env.DATABASE_NAME,
    host: process.env.DATABASE_HOST_ADDRESS,
    password: process.env.DATABASE_PASSWORD,
    port: process.env.DATABASE_PORT,
    user: process.env.DATABASE_USER
});

const handler = async (apiGatewayEvent) => {
    const {
        pathParameters: {
            make
        } = {}
    } = apiGatewayEvent;

    const query = 'SELECT * FROM cars WHERE MAKE = ?';
    const values = [
        make
    ];

    const [
        modelsList
    ] = await pool.query(query, values);

    return ({
        body: JSON.stringify({
            modelsList
        }),
        headers: {
            'Access-Control-Allow-Origin': '*'
        },
        statusCode: 200
    });
};

export default handler;
