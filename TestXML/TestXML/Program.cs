using Microsoft.TeamFoundation.Client;
using Microsoft.TeamFoundation.VersionControl.Client;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace TestXML
{
    class Program
    {
        static void Main(string[] args)
        {
            //string xmlfile = Path.GetFileName(@"https://vsogd.visualstudio.com/GDTools/Virtuoso%20World%20Wide/_versionControl?path=%24%2FGDTools%2FBuildProcessTemplates%2FBuildLogDrops%2FC179445%2FBuildLogFolder/BuildOutput.xml");
            //string xslfile = Path.GetFileName(@"https://vsogd.visualstudio.com/GDTools/Virtuoso%20World%20Wide/_versionControl?path=%24%2FGDTools%2FBuildProcessTemplates%2FBuildLogDrops%2FC179445%2FBuildLogFolder/VNextBuildOutput.xslt");
            //string outputhtmlfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\BuildOutput.htm");
            string xmlfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\BuildOutput.xml");
            string xslfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\VNextBuildOutput.xslt");
            string outputhtmlfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\BuildOutput.htm");
            XslCompiledTransform xslt = new XslCompiledTransform();
            xslt.Load(xslfile);
            xslt.Transform(xmlfile, outputhtmlfile);

            //using (var client = new WebClient())
            //{
            //    client.DownloadFile("https://vsogd.visualstudio.com/ES%20DevOps%20Services/_versionControl?path=%24%2FES%20DevOps%20Services%2FBuildProcessTemplates%2FBuildLogDrops%2FC179588%2FBuildLogFolder%2FBuildErrors.htm", "BuildErrors.htm");
            //}
            //string outputhtmlfile = Path.GetFileName(@"BuildErrors.htm");
            //Console.WriteLine("");
            //System.Diagnostics.Process.Start("https://vsogd.visualstudio.com/ES%20DevOps%20Services/_versionControl?path=%24%2FES%20DevOps%20Services%2FBuildProcessTemplates%2FBuildLogDrops%2FC179588%2FBuildLogFolder%2FBuildErrors.htm");

            //var path = "https://vsogd.visualstudio.com/ES%20DevOps%20Services/_versionControl?path=%24%2FES%20DevOps%20Services%2FBuildProcessTemplates%2FBuildLogDrops%2FC179588%2FBuildLogFolder%2FBuildErrors.htm";
            //var response = new HttpResponseMessage();
            //response.Content = new StringContent(File.ReadAllText(path));
            //response.Content.Headers.ContentType = new MediaTypeHeaderValue("text/html");
            //Console.WriteLine($"{response}");

            //Process.Start("https://vsogd.visualstudio.com/DefaultCollection//_apis/tfvc/items/$/ServicesCode-Assets/BuildProcessTemplates/BuildLogDrops/C179638/BuildLogFolder/BuildErrors.htm");

            //StringBuilder outputText = new StringBuilder();
            //string xmlFile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\BuildOutput.xml");
            //string xslfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\VNextBuildOutput.xslt");
           // string outputhtmlfile = Path.GetFileName(@"C:\Users\v-saiprs\Desktop\FxcopReport_SDL.htm");
            ////  XslCompiledTransform xslt = new XslCompiledTransform();
            ////   xslt.Load(xslfile);
            ////   xslt.Transform(xmlfile, outputhtmlfile);

            TfsTeamProjectCollection server = new TfsTeamProjectCollection(new Uri("https://vsogd.visualstudio.com/DefaultCollection/_apis/tfvc/items"));
            VersionControlServer version = server.GetService(typeof(VersionControlServer)) as VersionControlServer;
            Item item = version.GetItem(@"$/ServicesCode-Assets/BuildProcessTemplates/BuildLogDrops/C179638/BuildLogFolder/FxcopReport_SDL.htm");
             
            // Setup string container
            string content = string.Empty;

            // Download file into stream
            using (Stream stream = item.DownloadFile())
            {
                // Use MemoryStream to copy downloaded Stream
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    stream.CopyTo(memoryStream);

                    // Use StreamReader to read MemoryStream created from byte array
                    using (StreamReader streamReader = new StreamReader(new MemoryStream(memoryStream.ToArray())))
                    {
                        content = streamReader.ReadToEnd();
                    }
                }
            }
            Console.WriteLine($"{content}");

            using (FileStream aFile = new FileStream(outputhtmlfile, FileMode.Append, FileAccess.Write))
            using (StreamWriter sw = new StreamWriter(aFile))
            {
                sw.WriteLine(content);
            }

                Process.Start(outputhtmlfile);
            //using (TextReader reader = new StreamReader(xmlFile))
            //{
            //    XPathDocument xpathDoc = new XPathDocument(reader);

            //    TextReader xsltTextReader = null;
            //    xsltTextReader = new StreamReader(VNext_GetTransformedMainReportXSLT(@"C:\Users\v-saiprs\Desktop\VNextBuildOutput.xslt", "VNextBuildOutput.xslt"));
            //    XmlTextReader xmlTextReader = new XmlTextReader(xsltTextReader);

            //    XslTransform xslt = new XslTransform();
            //    xslt.Load(xmlTextReader);


            //    //XslTransform xslt = new XslTransform();
            //    //xslt.Load(xslfile);

            //    //create the output stream

            //    TextWriter writer = new StringWriter(outputText);
            //    xslt.Transform(xpathDoc, null, writer);
            //    Console.WriteLine($"{outputText}");
            //    reader.Close();
            //}

        }
        internal static string VNext_GetTransformedMainReportXSLT(string originalXSLTFile, string actualXSLTName)
        {
            string tempDir = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString());
            Directory.CreateDirectory(tempDir);
            string xsltTempFileforMail = Path.Combine(tempDir, actualXSLTName);
            File.Copy(originalXSLTFile, xsltTempFileforMail);
            XDocument xdoc = XDocument.Load(xsltTempFileforMail);

            var imagecoll = xdoc.Descendants(XName.Get("img", ""));
            foreach (var imageObj in imagecoll)
            {
                if (imageObj.Attribute(XName.Get("src", "")) != null)
                {
                    var srcValue = imageObj.Attribute(XName.Get("src", "")).Value;
                    srcValue = Path.GetFileNameWithoutExtension(srcValue);
                    imageObj.Attribute(XName.Get("src", "")).SetValue("cid:" + srcValue);
                }
                else
                {
                    var Atrribcoll = imageObj.Descendants("{http://www.w3.org/1999/XSL/Transform}attribute");
                    foreach (var attrib in Atrribcoll)
                    {
                        if (attrib.NodeType == XmlNodeType.Element && attrib.Attribute("name") != null && attrib.Attribute("name").Value == "src")
                        {
                            var imageFilePath = attrib.Value;
                            attrib.SetValue("cid:" + Path.GetFileNameWithoutExtension(imageFilePath));
                        }
                    }
                }
            }
            xdoc.Save(xsltTempFileforMail);
            return xsltTempFileforMail;
        }

    }
}
