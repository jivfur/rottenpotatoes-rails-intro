module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def highlight(colum)
    css={:title => " ", :release_date => " "}
    css[colum]="hilite"
    return css
  end
end
