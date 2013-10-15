# encoding: utf-8
# 为了解决本项目在ruby 1.8.7下运行引起的一些问题。

if defined?(Enumerable::Enumerator)
  Enumerable::Enumerator.class_eval do
    def [](*args)
      to_a[*args].join
    end
  end
end
