/*
 *  This sketch demonstrates how to set up a simple HTTP-like server.
 *  The server will set a GPIO pin depending on the request
 *    http://server_ip/gpio/0 will set the GPIO2 low,
 *    http://server_ip/gpio/1 will set the GPIO2 high
 *  server_ip is the IP address of the ESP8266 module, will be 
 *  printed to Serial when the module is connected.
 */

#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>

const char* ssid = "EE";             //��JWIFI�W��
const char* password = "12345678";     //��JWIFI�K�X

WiFiServer server(80);      //  �}�Ҧ��O�l��PORT 80


int incomeByte[7];
int data;
int z=0;
int sum;
int xo;
unsigned long error;
SoftwareSerial mySerial(5, 11); // RX, TX

void setup() {
  Serial.begin(115200);     // �t�׬�115200
  delay(10);

  Serial.begin(38400);
  mySerial.begin(2400);
  
  pinMode(2, OUTPUT);       //�}��2����X �O�l�W��D4
  digitalWrite(2, 0);       //�}��2���C�q��
  pinMode(13, OUTPUT);       //�}��2����X �O�l�W��D1
  digitalWrite(13, 0);       //�}��2���C�q��

  
  // WIFI�s�u�@�~
  Serial.println();   //�L�Ů�
  Serial.println();   //�L�Ů�
  Serial.print("Connecting to ");  //�L�X�s�u��WIFI
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);      //�ϥ�WIFI�M�K�X�}�l�s�u
  
  while (WiFi.status() != WL_CONNECTED) {   //�����L�a�j�� ���s�u�ɤ@�����X...
    delay(500);
    Serial.print(".");
  }
  Serial.println("");   //�s�u���\��|���X�s�u���\
  Serial.println("WiFi connected");
  
  // ���A���Ұ�
  server.begin();
  Serial.println("Server started"); 

  // �C�L�X�����A�����t�쪺IP
  Serial.println(WiFi.localIP());
}

void loop() {

  while (mySerial.available()){
 
    data=mySerial.read();
    if(data == 170){
      z=0;
      incomeByte[z]=data;
    }
    else{
      z++;
      incomeByte[z]=data;
    } 
    if(z==6)
    {
      sum=incomeByte[1]+ incomeByte[2]+ incomeByte[3] + incomeByte[4];
 
      if(incomeByte[5]==sum && incomeByte[6]==255 )
      {
 
        // Serial.print("Data OK! |");
        for(int k=0;k<7;k++)
        {
          Serial.print(incomeByte[k]);
          Serial.print("|");
        } 
 
        Serial.print(" Vo=");
        float vo=(incomeByte[1]*256.0+incomeByte[2])/1024.0*5.00;
        Serial.print(vo,3);
        Serial.print("v | ");
        float c=vo*700;
        // �o�̧ڭק�L���A2014�~11��23��Av1.1
        // ���qArduinio���a�]�i�H��X�@�װաI
        // ��M���Ǫ��ٻݭn�ۦ�Щw�@�G)  
        Serial.print(" PM2.5 = ");
        Serial.print(c,2);
        Serial.print("ug/m3 ");
        Serial.println();

       xo = c;
       
      }
      else{
        z=0;
        mySerial.flush();
        data='/0';
        for(int m=0;m<7;m++){
          incomeByte[m]=0;
        }
        /* 
         error++;
         Serial.print(" ### This is ");
         Serial.print(error);
         Serial.println(" Error ###");
         */
      }
      z=0;
    }
  }     

 
  // �T�{�O�_�s�u���A���O���ܸ��X�j��
  WiFiClient client = server.available();
  if (!client) {
    return;
  }
  
  // ���ݶǨ�o�Ӧ��A�����T���A�@�����@����
  Serial.println("new client");
  while(!client.available()){
    delay(1);
  }
  
  // ����ǹL�Ӫ��T����A�N���쪺�T���s��req
  String req = client.readStringUntil('\r');
  Serial.println(req);  //�L�X���쪺�T��
  client.flush();
  
  // �}�l��怜�쪺�T���ӨM�w������Ʊ�
  int val; int a; int b; 
  if (req.indexOf("/gpio/0") != -1)   //�p�G����gpio/0
    val = 0;  
  else if (req.indexOf("/gpio/1") != -1)  //�p�G����gpio/1
    val = 1;  
  else if (req.indexOf("/gpio/5") != -1)  //�p�G����gpio/1
    val = val;   
  else {                                   //�p�G�����L
    Serial.println("invalid request");
    client.stop();
    return;
  }

if (req.indexOf("/gpio/0") != -1)   //�p�G����gpio/0
    a = 1;  
  else if (req.indexOf("/gpio/1") != -1)  //�p�G����gpio/1
    a = 0; 
  else if (req.indexOf("/gpio/5") != -1)  //�p�G����gpio/1
    a = a;     
  else {                                   //�p�G�����L
    Serial.println("invalid request");
    client.stop();
    return;
  }

if (req.indexOf("/gpio/0") != -1)   //�p�G����gpio/0
   b = 0;  
else if (req.indexOf("/gpio/1") != -1)  //�p�G����gpio/1
    b = 0;  
else if (req.indexOf("/gpio/5") != -1)  //�p�G����gpio/1
    b = 1;         
  else {                                   //�p�G�����L
    Serial.println("invalid request");
    client.stop();
    return;
  }

  
  // Set GPIO2 according to the request
  digitalWrite(2, val);     //�̷Ӧ��쪺�T�����ܿO���G�t
  digitalWrite(13, a);

  client.flush();


  
  // �ǳƵo�����T�̪��^���A���e�Ohtml���榡�A�N���T�̷|����²�檺����
  String s = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\nPM2.5 is ";
  s += xo;  
  s += "ug/m3 now ";  
  s += "</html>\n";



  // �ǳƦn�o�����T��
  client.print(s);
  delay(1);
  Serial.println("Client disonnected");


if (b>0){
 digitalWrite(2, LOW);     //�̷Ӧ��쪺�T�����ܿO���G�t
 digitalWrite(13,LOW);
}
    //sensor  

}