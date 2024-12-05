const handler = async () => {
    console.log('Going to return alive...');

    return ({
        body: JSON.stringify({
            isAlive: true
        }),
        headers: {
            'Access-Control-Allow-Origin': '*'
        },
        statusCode: 200
    });
};

export default handler;
