//+------------------------------------------------------------------+
//|                                                 MAstrategies.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int MagicNumber= 100;
extern int Lots = 1;
extern string mycmt = "MyMA" ; 
extern int ShortMA = 50 ; 
extern int LongMA =  200 ;


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {


 //--- check for history and trading
   if(Bars<100 || IsTradeAllowed()==false)
      return;

 //--- calculate open orders by current symbol
   if(CountOrders()==0) CheckForOpen();
   else                 CheckForClose();
 //---

   
  }
//+------------------------------------------------------------------+

void  CheckForOpen() 
  {
     int res=0;
     if((iMA(NULL,0,ShortMA,0,MODE_SMA,PRICE_CLOSE,0)>iMA(NULL,0,LongMA,0,MODE_SMA,PRICE_CLOSE,0))) //+-- Buy
     {
        res=OrderSend(Symbol(),OP_BUY,Lots,Ask,0,0,0,mycmt,MagicNumber,0,Green);
     }
     if((iMA(NULL,0,ShortMA,0,MODE_SMA,PRICE_CLOSE,0)<iMA(NULL,0,LongMA,0,MODE_SMA,PRICE_CLOSE,0))) //+-- Sell
     {
        res=OrderSend(Symbol(),OP_SELL,Lots,Bid,0,0,0,mycmt,MagicNumber,0,Yellow);

     }
  }
  
void CheckForClose()
 {  
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(   OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber  )  
        {
         if(OrderType()==OP_BUY)  
           {
              if((iMA(NULL,0,ShortMA,0,MODE_SMA,PRICE_CLOSE,0)<iMA(NULL,0,LongMA,0,MODE_SMA,PRICE_CLOSE,0))) //+-- Close Buy
              {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Yellow);
              }
            
           }
         if(OrderType()==OP_SELL) 
           {
                if((iMA(NULL,0,ShortMA,0,MODE_SMA,PRICE_CLOSE,0)>iMA(NULL,0,LongMA,0,MODE_SMA,PRICE_CLOSE,0))) //+-- Close Sell
                {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Yellow);
                }
           
              
           }
        }
     }
 }



int CountOrders()
{
  int res=0;
  for(int i=0;i<OrdersTotal();i++)
  {
     OrderSelect(i,SELECT_BY_POS ,MODE_TRADES);
     if (OrderMagicNumber()==MagicNumber) res++;

   }
  return (res);
}

