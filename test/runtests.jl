using ObservableInterfaces
using Query
using DataFrames
using Base.Test

source = Foo(10)

file1 = TextFile("foo.txt", source)
file2 = TextFile("foo2.txt", source)
displaysink = ObservableInterfaces.ConsoleSink(source)

ObservableInterfaces.process(source)

mo = MapObservable(i->"Now with better $i", source)

displaysink2 = ConsoleSink(mo)

ObservableInterfaces.process(source)

x = source |> @map({foo=_}) |> Array
