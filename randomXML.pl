=
The MIT License (MIT)

Copyright (c) 2016 CSC - IT Center for Science, Population Register Centre (VRK)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=cut

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