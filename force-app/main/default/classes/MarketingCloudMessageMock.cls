global class MarketingCloudMessageMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {

        HttpResponse res = new HttpResponse();

        if (req.getEndpoint().endsWith('send')) {
            System.debug('Logging the message send callout mock');

            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"tokenId": "X2lkUG4tdTFXa3FueU9HanJCbUZCdzo3Njox"}');
            res.setStatusCode(202);


        } else if (req.getEndpoint().endsWith('requestToken')) {
            System.debug('Logging the auth callout mock');

            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"accessToken": "4tBX97Fe6ghJqFXkkNBg5ERh","expiresIn": 3479}');
            res.setStatusCode(200);

        } else {
            System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
        }

        return res;
    }
}
