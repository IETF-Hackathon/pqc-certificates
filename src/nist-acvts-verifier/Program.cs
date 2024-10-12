using System;
using System.IO;
using System.Security.Cryptography.X509Certificates;

class Program
{
    static int Main(string[] args)
    {
        // Validate command line arguments
        if (args.Length != 1)
        {
            Console.WriteLine("Usage: dotnet run <path-to-pem-file>");
            return 1; // Return non-zero exit code on failure
        }
        // Path to the PEM file from command line argument
        string pemFilePath = args[0];
        Console.WriteLine("File to read: " + pemFilePath);
        try
        {
            // Extract OID from the filename
            string fileName = Path.GetFileNameWithoutExtension(pemFilePath);
            string[] parts = fileName.Split(new[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length < 2)
            {
                Console.WriteLine("Invalid file name format. Expected format: <oid>_ta.pem");
                return 1; // Return non-zero exit code on failure
            }
            string oid = parts[0];
            Console.WriteLine("Algorithm OID to use: " + oid);
            // Read the PEM file content
            byte[] pemContent = File.ReadAllBytes(pemFilePath);

            return 0;
        }
        catch (Exception ex)
        {
            Console.WriteLine("An error occurred: " + ex.Message);
            return 1;
        }
    }
}