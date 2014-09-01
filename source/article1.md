## 從 Arduino 到 AVR 晶片(4) -- Blink with Timer (作者：Cooper Maa)

### 實驗目的

使用 Timer 計算時間，讓一顆燈號閃爍，每隔一秒切換一次燈號。 

### 材料

* Arduino 主板 x 1
* LED x 1

### 接線

把 LED 接到 Arduino 板子上，LED 長腳 (陽極) 接到 pin13，短腳 (陰極) 接到 GND，如下圖：

![](../img/ArduinoBlink1.png)

### 程式碼

先來看 Arduino 版本的 Blink 程式:

```CPP

/*
 * Blink.pde: 讓一顆燈號閃爍&#65292;每隔一秒切換一次燈號
 */

const int ledPin =  13;         // LED pin

void setup() {                
  pinMode(ledPin, OUTPUT);      // 把 ledPin 設置成 output pin 
}

void loop() {
  digitalWrite(ledPin, HIGH);   // 打開 LED 燈號 
  delay(1000);                  // 延遲一秒鐘
  digitalWrite(ledPin, LOW);    // 關閉 LED 燈號 
  delay(1000);                  // 延遲一秒鐘
}
```

這支程式是 Arduino 的入門程式，相信你應該很熟悉。

接下來我們改用 Timer 改寫程式，利用 Timer1 計算一秒鐘的時間:

```CPP

/*
 * BlinkWithTimer1.pde: 讓一顆燈號閃爍&#65292;每隔一秒切換一次燈號&#65292;使用 Timer 算時間
 */
 
const int ledPin =  13;         // LED pin

void setup() {
  pinMode(ledPin, OUTPUT);      // 把 ledPin 設置成 output pin 
  
  TCCR1A = 0x00;                // Normal mode, just as a Timer

  TCCR1B |= _BV(CS12);          // prescaler = CPU clock/1024
  TCCR1B &= ~_BV(CS11);       
  TCCR1B |= _BV(CS10);        

  TCNT1 = 0;
}

void loop() {
  digitalWrite(ledPin, HIGH);   // 打開 LED 燈號 
  delay1s();                    // 延遲一秒鐘
  digitalWrite(ledPin, LOW);    // 關閉 LED 燈號 
  delay1s();                    // 延遲一秒鐘 
}

void delay1s()
{
  while (TCNT1 <15625)         // Ticks for 1 second @16 MHz,prescale=1024
    ;  // do nothing
  
  TCNT1 = 0;
}
```

以 Arduino UNO 或 Duemilanove 為例，它們的時脈頻率是 16 MHz，如果把 Timer1 的 prescaler 設成 CPU clock/1024，那麼 Timer1 的 clock 便是:

Timer1 的時脈 = 16 MHz/1024 = 15625Hz

所以 Timer1 從 0 數到 15625 就是一秒鐘的時間。Timer1 是 16-bit 的，最大值可以到 65535。

把 Prescaler 設成 CPU clock/1024 的方法是:

```CPP
TCCR1B |= _BV(CS12);          // prescaler = CPU clock/1024
TCCR1B &= ~_BV(CS11);       
TCCR1B |= _BV(CS10);       
```

### 使用中斷

底下的程式是改用 Timer Overflow 中斷的版本:

```CPP

/*
 * BlinkWithInterrupt.pde: 讓一顆燈號閃爍&#65292;每隔一秒切換一次燈號&#65292;使用 Timer 算時間
 */
 
const int ledPin =  13;         // LED pin

void setup() {
  pinMode(ledPin, OUTPUT);      // 把 ledPin 設置成 output pin 
  
  TCCR1A = 0x00;                // Normal mode, just as a Timer

  TCCR1B |= _BV(CS12);          // prescaler = CPU clock/1024
  TCCR1B &= ~_BV(CS11);       
  TCCR1B |= _BV(CS10);    
  
  TIMSK1 |= _BV(TOIE1);         // enable timer overflow interrupt
  
  TCNT1 = -15625;               // Ticks for 1 second @16 MHz,prescale=1024
}

void loop() {
  // do nothing
}

ISR (TIMER1_OVF_vect)
{    
  PORTB ^= _BV(5);              // Toggle LED, PB5 = Arduino pin 13
  TCNT1 = -15625;               // Ticks for 1 second @16 MHz,prescale=1024
}
```

這次 Prescaler 仍然使用 CPU clock/1024，所以，要算一秒鐘，一樣是讓 Timer1 從 0 數到 15625 就可算出。除了啟用 Timer overflow 中斷外，我們還得寫個 ISR:

```CPP
ISR (TIMER1_OVF_vect)
{    
  PORTB ^= _BV(5);              // Toggle LED, PB5 = Arduino pin 13
  TCNT1 = -15625;               // Ticks for 1 second @16 MHz,prescale=1024
}
```

當發生中斷跑到 ISR 時，代表時間已經經過 1 秒鐘，所以接著就切換燈號，然後再把 -15625 載入到 TCNT1，讓 Timer1 在一秒鐘後再次觸發中斷。

我們也可以不用 Prescaler，像這樣:

```CPP
/*
 * BlinkWithNoPrescaling.pde: 讓一顆燈號閃爍&#65292;每隔一秒切換一次燈號&#65292;使用 Timer 算時間
 */

volatile unsigned int count = 0; 
const int ledPin =  13;         // LED pin

void setup() {
  pinMode(ledPin, OUTPUT);      // 把 ledPin 設置成 output pin 
  
  TCCR1A = 0x00;                // Normal mode, just as a Timer

  TCCR1B &= ~_BV(CS12);         // no prescaling
  TCCR1B &= ~_BV(CS11);       
  TCCR1B |= _BV(CS10);     
  
  TIMSK1 |= _BV(TOIE1);         // enable timer overflow interrupt
  
  TCNT1 = 0;
}

void loop() {
  // do nothing
}

ISR (TIMER1_OVF_vect)
{  
  count++;
  
  if (count == 244) {             // overflow frequency = 16 MHz/65536 = 244Hz
    PORTB ^= _BV(5);              // Toggle LED, PB5 = Arduino pin 13
    count = 0;
  }  
}
```

不用 Prescaler 的時候，Timer 的 clock 就是 16 MHz:

Timer1 overflow frequency =  16 MHz/65536 = 244 Hz

所以只要發生 244 次 Timer overflow 中斷，就代表已經過了 1 秒鐘的時間。

### 補充說明

因為 Timer0 已經被 Arduino 拿去用了，所以這篇教學使用 Timer1 示範。

### 延伸閱讀

* [Arduino 筆記 – Lab1 Blinking a LED](http://coopermaa2nd.blogspot.com/2010/12/arduino-lab1-blinking-led.html)


【本文作者為馬萬圳，原文網址為： <http://coopermaa2nd.blogspot.tw/2011/07/41-blink-with-timer.html> ，由陳鍾誠編輯後納入本雜誌】

