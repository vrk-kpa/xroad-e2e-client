use strict;

sub soapRandom { return "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:id=\"http://x-road.eu/xsd/identifiers\" xmlns:xrd=\"http://x-road.eu/xsd/xroad.xsd\">
    <SOAP-ENV:Header>
        <xrd:client id:objectType=\"SUBSYSTEM\">
            <id:xRoadInstance>CONFIGURE_THIS</id:xRoadInstance>
            <id:memberClass>CONFIGURE_THIS</id:memberClass>
            <id:memberCode>CONFIGURE_THIS</id:memberCode>
            <id:subsystemCode>TestClient</id:subsystemCode>
        </xrd:client>
        <xrd:service id:objectType=\"SERVICE\">
            <id:xRoadInstance>CONFIGURE_THIS</id:xRoadInstance>
            <id:memberClass>CONFIGURE_THIS</id:memberClass>
            <id:memberCode>CONFIGURE_THIS</id:memberCode>
            <id:subsystemCode>TestService</id:subsystemCode>
            <id:serviceCode>getRandom</id:serviceCode>
            <id:serviceVersion>v1</id:serviceVersion>
        </xrd:service>
        <xrd:userId>CONFIGURE_THIS</xrd:userId>
        <xrd:id>ID11234</xrd:id>
        <xrd:protocolVersion>4.0</xrd:protocolVersion>
    </SOAP-ENV:Header>
    <SOAP-ENV:Body>
        <ns1:getRandom xmlns:ns1=\"http://test.x-road.fi/producer\"/>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>"; }

1;
