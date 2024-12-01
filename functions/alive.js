const handler = async () => ({
    body: JSON.stringify({
        isAlive: true
    }),
    headers: {
        'Access-Control-Allow-Origin': '*'
    },
    statusCode: 200
});

export default handler;
