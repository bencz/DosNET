namespace System
{
    public abstract class Array
    {
        internal readonly int _length;
        
        public int Length => _length;
        
        public int GetLength(int dimension)
        {
            if (dimension != 0)
                throw new IndexOutOfRangeException();
            return _length;
        }
        
        public int Rank => 1;
        
        public static void Copy(Array sourceArray, Array destinationArray, int length)
        {
            Copy(sourceArray, 0, destinationArray, 0, length);
        }
        
        [Asm386Implementation(@"
            MOV ESI, {ARG0}
            MOV EDI, {ARG2}
            MOV ECX, {ARG4}
            ADD ESI, {ARG1}
            ADD EDI, {ARG3}
            REP MOVSB
        ")]
        public static extern void Copy(Array sourceArray, int sourceIndex, Array destinationArray, int destinationIndex, int length);
        
        public static void Clear(Array array, int index, int length)
        {
            RuntimeHelpers.ArrayClear(array, index, length);
        }
        
        public static int IndexOf(Array array, Object value)
        {
            return IndexOf(array, value, 0, array.Length);
        }
        
        public static int IndexOf(Array array, Object value, int startIndex, int count)
        {
            for (int i = startIndex; i < startIndex + count && i < array.Length; i++)
            {
                if (Object.Equals(RuntimeHelpers.ArrayGetValue(array, i), value))
                    return i;
            }
            return -1;
        }
    }
}
