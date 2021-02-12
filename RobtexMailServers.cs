using System;
using System.Net.Http;
using System.Text.RegularExpressions;
namespace RobtexSharp
{
    class Program
    {
        static void Main(string[] args)
        {
         new MyProgram().Robtex("ping.eu");
        }
    }
    class MyProgram
    {
        public  void Robtex(string i)
        {
            using (var httpClient = new HttpClient())
            {
                var Response = httpClient.GetStringAsync("https://www.robtex.com/dns-lookup/"+i);
                if  (Response.Result.Contains("IP numbers of the mail servers"))
                {
                 string Result = Response.Result.Split("IP numbers of the mail servers")[1];
                 Result = Result.Remove(Result.IndexOf("results shown."));
                 Regex ip = new Regex(@">(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})<");
                 MatchCollection _result = ip.Matches(Result);
                 foreach (Match bla in _result)  
                 {
                    Console.WriteLine(bla.Groups[1].Value);                
                 }
                }
            }
        }
    }
}
