using System;
using System.Xml.Linq;

public class Program
{
    public static void Main()
    {
        var snapShot = new XElement("Snapshot", new XAttribute("DataDate", DateTime.Today.ToString("yyyy-MM-dd")));
        var instruments = new XElement("Instruments");
        instruments.Add(CreateInstrument("Equity", "1", "HSBC Class A"));
        instruments.Add(CreateInstrument("Equity", "2", "Facebook"));
        CreateInstrumentWithSingleUnderlying(instruments, "EquityOption", "3", "Call Option On Facebook");
        //In a loop add all instruments from all portfolios
        snapShot.Add(instruments);
        var portfolios = new XElement("Portfolios");
        portfolios.Add(CreatePortfolio("P123"));
		portfolios.Add(CreatePortfolio("P456"));
        //In a loop add all portfolios
        snapShot.Add(portfolios);
        Console.WriteLine(new XDocument(snapShot));
    }
    public static XElement CreateInstrument(string assetClass, string instrumentId, string instrumentName) 
    { 
        return new XElement(assetClass,
            new XAttribute("InstrumentId", instrumentId),
            new XAttribute("InstrumentName", instrumentName));
            //Add all other required instrument properties per asset class from https://docs.fundapps.co/disclosureProperties.html#InstrumentProperties
    }
    public static void CreateInstrumentWithSingleUnderlying(XElement instruments, string assetClass, string instrumentId, string instrumentName) 
    { 
		var underlyingInstrumentId = "U" + instrumentId;
		instruments.Add(CreateInstrument("Equity", underlyingInstrumentId, "U"+ instrumentName));
		var derivative = CreateInstrument("Option", instrumentId, instrumentName);
		derivative.Add(new XElement("Component", new XAttribute("InstrumentId", underlyingInstrumentId)));
		instruments.Add(derivative);
    }
	public static XElement CreatePortfolio(string portfolioId)
    {
        var portfolio = new XElement("Portfolio", new XAttribute("PortfolioId", portfolioId));
        portfolio.Add(CreateAsset(portfolioId, "1", 100));
        portfolio.Add(CreateAsset(portfolioId, "2", 200));
        portfolio.Add(CreateAsset(portfolioId, "3", 300));
        //In a loop add all assets for this portfolio
        return portfolio;
    }
    public static XElement CreateAsset(string portfolioId, string instrumentId, int quantity) 
    {
        return new XElement("Asset", 
            new XAttribute("AssetId", portfolioId+"/"+instrumentId),
            new XAttribute("InstrumentId", instrumentId),
            new XAttribute("Quantity", quantity));
            //Add all other required instrument properties per asset class from https://docs.fundapps.co/disclosureProperties.html#AssetProperties
    }
}
