console.log("hello world");
const { convert } = require("html-to-text");

const options = {
  selectors: [
    { selector: "img", format: "skip" },
    { selector: "a", options: { ignoreHref: true } },
  ],
};

const html = `
<!doctype html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="target-densitydpi=device-dpi">
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="HandheldFriendly" content="true">
    <meta name="MobileOptimized" content="width">
    <title>HDFC BANK</title><!-- Facebook sharing information tags -->
    <!--<meta property="og:title" content="HDFC BANK" />-->
    <style type="text/css">
        @media screen and (min-device-width: 320px) and (max-device-width: 768px) {
            table {
                width: 100%;
            }

            .td {
                padding: 0px 25px;
                text-align: left;
            }

            .heading {
                text-align: center;
                padding: 0px 25px;
            }

            .cta {
                padding: 0px 25px;
                text-align: center;
            }
        }
    </style>
</head>

<body data-new-gr-c-s-loaded="14.1101.0">
    <table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
        <tbody>
			  <tr>
                <td style="border-bottom:1px solid #cccccc; border-top:1px solid #cccccc; border-left:1px solid #cccccc;border-right:1px solid #cccccc;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td valign="top" bgcolor="#dcddde" style="line-height:0px;background-color:#dcddde; border-left:1px solid #dcddde;"><a href="https://trkt.aclmails.in/v1/r/xw%2BDXPQSl5nR1dzfxIZIQStV4c7LdpHuQrrKW8kTjhifyhN7wjjlVltMyz%2F6pReyPxtACiafghC%2BWvJfZR1UJCHK8wNdd2%2FFWXyzWzX769saUwcnHqTyOCod%2Bu%2BWd6sqwZJIZwW5lX3c8sXKFdUZrncsdS50Mj2Bub7DwLKEIzvfQpSN65iAVq3ZbuEm%2BJCvMnHA4AmXWp1LeJz6rJ9zr2vJj8qXl5Q67G993kd2pzcMLWyIMCmw850vWyS5inNURqWM1WS9b3beMHwB%2B5opqjoqWIYo0ULZ4ZFBwBNeOiXYyr2bDrzAG%2BdfJibpXGIyCmrBdWOA61nKqU%2F8ccaAFhbMI6wd1YBa8LUZIFB%2BJCFaLGwXvV8Oc591iDafGeK1boeqY9XB0ND4vMyUDodxsA%3D%3D" target="_blank"><img src="https://img.pinchappmails.com/hdfc/images/2024/march/D3.jpg" style="display: block; vertical-align: top" alt width="100%" border="0"></a></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="20"></td>
            </tr>
            <tr>
                <td valign="top" bgcolor="#dcddde" style="line-height:0px;background-color:#dcddde; border-left:1px solid #dcddde;"><img src="https://wgjpss.stripocdn.email/content/guids/CABINET_d17330eb5cbe5af68cf444e0d9b181ad116d88b22fb8b3fd1c93e1846c59af76/images/nmbandnew.jpg" alt width="100%" border="0"></td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td valign="top" align="center">
                                    <table align="center" width="550" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td width="550" valign="top" align="center">
                                                    <table align="center" width="100%" border="0" cellspacing="0" cellpadding="0" style="width:100% !important; text-align: center">
                                                        <tbody>
                                                            <tr>
                                                                <td height="15"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td valign="top" align="center">
                                    <table align="center" width="550" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td width="550" valign="top" align="center">
                                                    <table align="center" width="100%" border="0" cellspacing="0" cellpadding="0" style="width:100% !important; text-align: center">
                                                        <tbody>
                                                            <tr>
                                                                <td height></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" valign="middle" style="font-family:Arial; font-size:16px; line-height:22px; color:#000; font-weight: normal; text-align: left" class="td esd-text">Dear CardHolder, <br> <br>Thank you for using your HDFC Bank Debit Card ending 3932 for Rs 159.00 at YOUTUBE CYBS SI on 28-05-2025 21:06:00. <br> <br>After the above transaction, the available balance on your card is Rs 583927.38. <br> <br>For more details on this transaction please visit Netbanking-Login here - Accounts. <br> <br>Not you? Please SMS BLOCK DEBIT CARD 3932 to 7308080808 to block the card immediately or call on 18002586161 to report this transaction. <br> <br>Regards <br>HDFC Bank <br> <br>(This is a system generated mail and should not be replied to) <br>


</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="25"></td>
                                                            </tr>
															<tr>
                                                                <td align="left" valign="middle" style="font-family:Arial; font-size:16px; line-height:22px; color:#000; font-weight: normal; text-align: left" class="td esd-text">
</td>
                                                            </tr>
                                                           
                                                            <tr>
                                                                <td height="25"></td>
                                                            </tr>
															<tr>
                                                                <td align="left" valign="middle" style="font-family:Arial; font-size:16px; line-height:22px; color:#000; font-weight: normal; text-align: left; border-bottom: 2px solid #cccccc; padding-bottom: 0px" class="td esd-text"></td>
                                                            </tr>
                                                            <tr>
                                                                <td height="15"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
          <tr>
                <td valign="top"  style="line-height:0px; border-left:0px solid #dcddde; padding-bottom: 5px"><img src="https://img.pinchappmails.com/hdfc/images/2024/july/Footerbanner_NEW_Aug.jpg" alt width="100%" border="0"></td>
            </tr>
            
            <tr>
                <td style="font-family:Arial,Helvetica,sans-serif;color:#000000;padding-bottom:5px;padding-top:5px;text-align:left;font-size:0.5rem;border:none;line-height:12px;padding-left:15px;padding-right:15px" align="left" class="esd-text">For more details on Service charges and Fees, <a href="https://trkt.aclmails.in/v1/r/NC0ifk5VD%2F5AY2v%2FbYezwVh%2BC4LgW5%2F6yMabW4JDItDmZBGZZWCFRQ8PKGwrOC7dWkXRYwgTqFsBjqy9lJiIPtmxXOtxT8g1qsuPVBmuCT2UDF9hdxyF1HrSaC1qTPOpWVJpBxdfb3%2FblB9NDFz38nbCM0iTUA5%2FW6MPg6OGGYxsYdcrU0Vlb%2Bwwl0Oq8UhK8ho94oV%2Bep007sthxh5hDdPDWdcxRvSQERN4Nvs9Sn6W%2B%2FomnERYIgPHY%2Fix7kE6d%2BLd1ZlGq2TiKCqy2xuIgEle23HQ3%2F%2BGXjOSHNuhMhQKBzTc5WKs7aLStRMtsGOfKuY%3D" style="text-decoration:underline;color:#004b8d;outline:none" target="_blank"><strong> click here.</strong></a></td>
            </tr>
            
            
            <tr>
                <td style="font-family:Arial,Helvetica,sans-serif;color:#000000;text-align:left;font-size:0.5rem;border:none;padding-left:15px" align="left" width="30%" class="esd-text">© HDFC Bank <span style="font-size: 3px"></span></td>
            </tr>
			  
           
        </tbody>
    </table>
</body>

</html><img src="https://trkt.aclmails.in/v1/w/BiywVzPxCIJYhz2Bi%2BMZdbFZ1T8ozeX3Hib0nNZgkRP44U%2FmW2WjQytf1T%2BCQ%2FRQYLnnmQ4QuTEHA%2FLYVaOhhHe2woRSUfbLSvTsgBiOXhwbAa8DsxAb%2FQqtglXcW9yKTfT6MXiUvzOwmc32extASnfUmhIZ7TMWpymgXVz2dUyi9E7BNXbIkv7Ik4HHA85uViu41xXh1xVQ3EvwiHWZDD%2FfjbxBq5vzJjovHSQd"  width="1" height="1" border="0">
`;

const plainText = convert(html, options);
console.log(plainText);
