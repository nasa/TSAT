function MSK_SEC_Enables3_TSAT(var,i,pref)

A = get_param(gcb,'MaskEnables');
for n = 1:length(i)
    switch pref
        case 'en' % turn output on when checked
            switch var
                case 'on'
                    A(i(n)) = {'on'};
                case 'off'
                    A(i(n)) = {'off'};
                otherwise
                    A(i(n)) = {'on'};
            end
        case 'dis' % turn output off when checked
            switch var
                case 'on'
                    A(i(n)) = {'off'};
                case 'off'
                    A(i(n)) = {'off'};
                otherwise
                    A(i(n)) = {'on'};
            end
    end
end
set_param(gcb, 'MaskEnables',A);