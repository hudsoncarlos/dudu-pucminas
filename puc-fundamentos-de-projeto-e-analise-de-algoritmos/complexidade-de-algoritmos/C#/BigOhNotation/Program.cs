﻿// See https://aka.ms/new-console-template for more information
using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Mathematics;
using BenchmarkDotNet.Order;
using BenchmarkDotNet.Running;
using System.Text;

BenchmarkRunner.Run<BigOBenchmarks>();

[Orderer(SummaryOrderPolicy.FastestToSlowest)]
[RankColumn(NumeralSystem.Arabic)]
[MarkdownExporter]
public class BigOBenchmarks
{
    readonly List<int> OrderedNumbers =
        [
            1, 2, 4, 6, 10, 14, 15, 19, 20, 34, 36, 38, 40, 42, 50, 52, 55, 60, 61, 62, 63, 67, 70, 78, 80, 82, 84, 86, 88, 90, 92, 93, 99, 101, 105, 107, 110, 115,118
        ];

    readonly List<int> UnorderedNumbers =
        [
            2, 23, -575, 1, -400, 8, 44, -90, 0, 4, 180, -32, 323, 73, 59, 663, 35, 45, -67, 28, 3, 5, -5, 52, 7, 62, -20, 9, 92, 63, -342, 12, 53, 200, 234, 756, 456
        ];

    /// <summary>
    /// 
    /// O(1) (constante)
    /// - Não há crescimento do número de operações, pois não depende do volume de dados de entrada (n).
    ///     
    /// </summary>
    [Benchmark(Description = "O(1)")]
    public void BigO_1()
    {
        var isEven = IsEven(3);
    }

    /// <summary>
    /// 
    /// O(log n) (logaritmo)
    /// - O crescimento do número de operações é menor do que o do número de itens.
    ///     
    /// </summary>
    [Benchmark(Description = "O(log n)")]
    public void BigO_LogN()
    {
        BinarySearch(OrderedNumbers, 52);
    }

    /// <summary>
    /// 
    /// O(n) (linear)
    /// - O crescimento no número de operações é diretamente proporcional ao crescimento do número de itens.
    ///     
    /// </summary>
    [Benchmark(Description = "O(n)")]
    public void BigO_N()
    {
        SimpleLoop(84);
    }

    /// <summary>
    /// 
    /// O(n log n) (linearitmica ou quasilinear)
    /// - É o resultado das operações(log n) executada n vezes.
    ///     
    /// </summary>
    [Benchmark(Description = "O(n log n)")]
    public void BigO_NLogN()
    {
        OrderingMergeSort();
    }

    /// <summary>
    /// 
    /// O(n^2) (quadrático)
    /// - Ocorre quando os itens de dados são processados aos pares, muitas vezes com repetições dentro da outra.
    ///     
    /// </summary>
    [Benchmark(Description = "O(n^2)")]
    public void BigO_N2()
    {
        NestedLoop();
    }

    /// <summary>
    /// 
    /// O(2^n) (exponencial)
    /// - A medida que n aumenta, o fator analisado(tempo ou espaço) aumenta exponencialmente.
    ///     
    /// </summary>
    [Benchmark(Description = "O(2^n)")]
    public void BigO_2n()
    {
        TowerOfHanoi(13, 'A', 'B', 'C');
    }

    /// <summary>
    /// O(n!) (fatorial)
    /// - O número de instruções executadas cresce muito rapidamente para um pequeno número de dados.
    /// </summary>
    /// 
    /// Exemplo para este exemplo é o caixeiro viajante


    // O(1)
    public static bool IsEven(int number)
    {
        return number % 2 == 0;
    }

    // O(log n)
    private static int BinarySearch(List<int> numberElements, int valuesToBeSearched)
    {
        if (numberElements == null)
        {
            throw new ArgumentNullException(nameof(numberElements));
        }

        if (numberElements[0] > valuesToBeSearched)
            return -1;

        if (valuesToBeSearched > numberElements[numberElements.Count - 1])
            return -1;

        int upperBound = numberElements.Count;
        int lowerBound = 0;

        while (lowerBound < upperBound)
        {
            int mid = (upperBound + lowerBound) / 2;
            if (numberElements[mid] < valuesToBeSearched)
            {
                lowerBound = mid;
            }
            else if (numberElements[mid] > valuesToBeSearched)
            {
                upperBound = mid;
            }
            else
            {
                return mid;
            }
        }

        return -1;
    }

    public bool SimpleLoop(int searchedNumber)
    {
        // O(n)
        foreach (var element in OrderedNumbers)
        {
            if (element == searchedNumber)
                return true;
        }

        return false;
    }

    // O(n log n)"
    public static int[] MergeSort(int[] inputItems, int lowerBound, int upperBound)
    {
        if (lowerBound < upperBound)
        {
            int middle = (lowerBound + upperBound) / 2;

            MergeSort(inputItems, lowerBound, middle);
            MergeSort(inputItems, middle + 1, upperBound);

            int[] leftArray = new int[middle - lowerBound + 1];
            int[] rightArray = new int[upperBound - middle];

            Array.Copy(inputItems, lowerBound, leftArray, 0, middle - lowerBound + 1);
            Array.Copy(inputItems, middle + 1, rightArray, 0, upperBound - middle);

            int i = 0;
            int j = 0;
            for (int count = lowerBound; count < upperBound + 1; count++)
            {
                if (i == leftArray.Length)
                {
                    inputItems[count] = rightArray[j];
                    j++;
                }
                else if (j == rightArray.Length)
                {
                    inputItems[count] = leftArray[i];
                    i++;
                }
                else if (leftArray[i] <= rightArray[j])
                {
                    inputItems[count] = leftArray[i];
                    i++;
                }
                else
                {
                    inputItems[count] = rightArray[j];
                    j++;
                }
            }
        }

        return inputItems;
    }

    // O(n log n)"
    public void OrderingMergeSort()
    {
        var numbersMergeSort = MergeSort(UnorderedNumbers.ToArray<int>(), 0, UnorderedNumbers.Count - 1).ToList<int>();

        var sbMergeSort = new StringBuilder();

        for (int count = 0; count < numbersMergeSort.Count; count++)
        {
            sbMergeSort.Append(numbersMergeSort[count].ToString() + "==>");
        }

        Console.WriteLine(sbMergeSort.ToString());
    }

    public static void NestedLoop()
    {
        var n2Array = new int[20000];

        int counter = 0;

        // O(n * n) = O(n²)

        for (int i = 0; i < n2Array.Length; i++)         // O(n)
        {
            for (int j = 0; j < n2Array.Length; j++)     // O(n)
            {
                counter++;
            }
        }

        Console.WriteLine("O(n^2) finished in " + counter.ToString() + " cycles.");
    }

    public static void TowerOfHanoi(int n, char from_rod, char to_rod, char aux_rod)
    {
        if (n == 0)
        {
            return;
        }

        // O(2^n)
        TowerOfHanoi(n - 1, from_rod, aux_rod, to_rod);

        Console.WriteLine($"Move disk {n} from rod {from_rod} to rod {to_rod}");

        TowerOfHanoi(n - 1, aux_rod, to_rod, from_rod);
    }
}