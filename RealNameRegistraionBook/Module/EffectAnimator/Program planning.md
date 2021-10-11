#規劃中
 **Renderer:**   
 `繪圖顯示，接收變數依照喧染器種類繪圖。`.      
 _func：_   
          
*   draw(ctx, value: CGFloat, angle: CGFloat)    

_Property：_.    
 
* color：顏色.   
* var value： 目前圖畫的value
* angle：目前繪圖角度
* text ...

_Type：(enum)_

* position：繪圖開始位子。ex: left(_ cgfloat), top, bottom, right

**Peotocol**  
`各種基礎繪圖協定`

**BasicView**    
`基本類型View，規劃有：永久動畫類、限時動畫類、position動畫類`    
* 永久動畫類：value：0~ 2pi，使用三角函數 -1 ~ 1 讓動畫永久執行
*  限時動畫類：DisplayLink 執行，Date().TimeInterval 計時。
*  Position 類：動畫到特定位子即停止類別。
