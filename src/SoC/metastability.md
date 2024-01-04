# Metastability 亚稳态

用两个寄存器解决亚稳态

这个博客讲比较清楚[Metastability and synchronization](https://fys4220.github.io/part-vhdl/vhdl_metastability.html)，但还不够。

自己梳理一遍：

两个寄存器能解决亚稳态是因为，（隐式地）假设了亚稳态稳定时间很短，能够在下个setup time到来之前稳定（稳定到新值或者旧值），见下图。
有了这个假设两个寄存器的效果：寄存器2的值不会出现亚稳态。

![](https://fys4220.github.io/_images/wave_metastability_synchronization_registers_new_value.png)
![](https://fys4220.github.io/_images/wave_metastability_synchronization_registers_old_value.png)
